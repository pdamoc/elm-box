module Box where

import Task exposing (Task)
import Signal 
import Json.Encode as JEnc
import Json.Decode as JDec

import Html exposing (Html, div)

type alias Message = Task () ()

type alias Leaf output = 
  { init : JEnc.Value
  , next : JEnc.Value -> JEnc.Value-> (JEnc.Value, List Message) 
  , view : JEnc.Value -> List output -> output
  }

type alias BoxConfig action model output = 
  { init : model
  , next : (action -> model -> (model, List Message))
  , view : (Signal.Address action -> model -> List output -> output)
  , actionDecoder : JDec.Decoder action
  , actionEncoder : (action -> JEnc.Value)
  , modelDecoder : JDec.Decoder model
  , modelEncoder : (model -> JEnc.Value)
  }

type Box output =  Box (Leaf output) (List (Int, Box output) ) 

type Action = Own JEnc.Value | Child Int Action

type alias App output =
  { output : Signal output 
  , msgs : Signal (Task () (List ()))  
  }


toBox : BoxConfig action model output -> List (Box output) -> Signal.Address Action -> Box output
toBox boxCfg children address = 
  let 
    decodedNext : JEnc.Value -> JEnc.Value -> (JEnc.Value, List Message)
    decodedNext encodedAction encodedModel = 
      let 
        dec = 
          (JDec.decodeValue boxCfg.actionDecoder encodedAction) 
          `Result.andThen`
          (\a -> Result.map (\m ->(a,m)) <| JDec.decodeValue boxCfg.modelDecoder encodedModel)
      in 
        case dec of
          Err e -> (encodedModel, [])
          Ok (a, m) -> 
            let 
              (m', msgs) = boxCfg.next a m
            in 
              (boxCfg.modelEncoder m', msgs)
    
    view model children =
      let 
        model' = ((Maybe.withDefault boxCfg.init) << Result.toMaybe << (JDec.decodeValue boxCfg.modelDecoder)) model
        decodedAddress = Signal.forwardTo address <| Own << boxCfg.actionEncoder
      in 
        boxCfg.view decodedAddress model' children

    leaf =
    { init = boxCfg.modelEncoder boxCfg.init
    , next = decodedNext
    , view = view
    }
  in 
    Box leaf (List.indexedMap (,) children)

type alias ActionAddress = Signal.Address Action

vBox : List (ActionAddress -> Box Html) -> ActionAddress -> Box Html
vBox children address =
  let 
    view m children = 
      div []
      children

  in 
    Box { init = JEnc.null
    , next = (\a m -> (m, []))
    , view = view
    } (List.indexedMap (\idx c -> (idx, c (Signal.forwardTo address (Child idx)) )) children)



start : (Signal.Address Action -> Box output) -> App output 
start  unAddressedWidget =
  let 
    mailbox = Signal.mailbox (Own JEnc.null)
    (Box leaf children) = unAddressedWidget mailbox.address
    init = (Box leaf children, [])

    next : Action -> (Box output, List Message) -> (Box output, List Message)
    next a ((Box leaf children), msgs) = 
      case a of 
        Own act -> 
          let 
            (state', msgs') = leaf.next act leaf.init 
          in 
            (Box {leaf| init=state'} children, msgs')

        Child cIdx act -> 
          let 
            update (idx, box) = 
              if idx == cIdx 
              then 
                let 
                  (box', boxMsgs) = next act (box, [])
                in
                  ((idx, box'), boxMsgs)
              else ((idx, box), [])
            (children', msgs') = List.unzip <| List.map update children
          in 
            ((Box leaf children'), msgs++(List.concat msgs'))

    out = Signal.foldp next init mailbox.signal

    view (Box leaf children) = 
      case children of
        [] -> leaf.view leaf.init []
        xs -> leaf.view leaf.init (List.map view <| List.map snd children) 

  in 
    { output = Signal.map view <| Signal.map fst out
    , msgs = Signal.map (\(_, msgs)-> Task.sequence msgs) out
    }