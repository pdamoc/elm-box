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
  , view : JEnc.Value -> List output -> ActionAddress -> output
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

type Action = Own JEnc.Value | Child Int Action

type alias ActionAddress = Signal.Address Action

type Box output =  Box ActionAddress (Leaf output) (List (Int, Box output) ) 

type alias App output =
  { output : Signal output 
  , msgs : Signal (Task () (List ()))  
  }

defaultActionAddress : ActionAddress
defaultActionAddress = .address <| Signal.mailbox (Own JEnc.null)

toBox : BoxConfig action model output -> List (Box output) -> List (action -> List Message) -> Box output
toBox boxCfg children actionHandlers = 
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
              ahMsgs = List.concatMap (\ah -> ah a) actionHandlers
            in 
              (boxCfg.modelEncoder m', msgs++ahMsgs)
    
    view model children address =
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
    Box defaultActionAddress leaf (List.indexedMap (,) children)


vBox : List (Box Html) -> Box Html
vBox children =
  let 
    view m children address = 
      div []
      children
  in 
    Box defaultActionAddress { init = JEnc.null
    , next = (\a m -> (m, []))
    , view = view
    } (List.indexedMap (,) children)


updateAddress : ActionAddress -> Box output -> Box output
updateAddress newAddr (Box oldAddr leaf children) =
  let 
    updateChild (idx, box) =
      let   
        childAddress = (Signal.forwardTo newAddr (Child idx))
      in 
        (idx, updateAddress childAddress box) 

  in 
    case children of 
      [] -> Box newAddr leaf children 
      xs -> Box newAddr leaf <| List.map updateChild children


start : Box output -> App output 
start box =
  let 
    mailbox = Signal.mailbox (Own JEnc.null)
    (Box address leaf children) = updateAddress mailbox.address box

    init = (Box mailbox.address leaf children, [])

    next : Action -> (Box output, List Message) -> (Box output, List Message)
    next a ((Box address leaf children), msgs) = 
      case a of 
        Own act -> 
          let 
            (state', msgs') = leaf.next act leaf.init 
          in 
            (Box address {leaf| init=state'} children, msgs')

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
            ((Box address leaf children'), msgs++(List.concat msgs'))

    out = Signal.foldp next init mailbox.signal

    view (Box address leaf children) = 
      case children of
        [] -> leaf.view leaf.init [] address
        xs -> leaf.view leaf.init (List.map view <| List.map snd children) address

  in 
    { output = Signal.map view <| Signal.map fst out
    , msgs = Signal.map (\(_, msgs)-> Task.sequence msgs) out
    }