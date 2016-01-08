module Box where

import Task exposing (Task)
import Signal 
import Json.Encode as JEnc
import Json.Decode as JDec

import Mouse 
import Keyboard
import Char

type alias Message = Task () ()

type alias Leaf output = 
  { init : JEnc.Value
  , next : JEnc.Value -> JEnc.Value-> (JEnc.Value, List Message) 
  , view : JEnc.Value -> List output -> output
  , toMessage : (Action -> Message)
  }

type alias BoxConfig action model output = 
  { init : model
  , next : (action -> model -> (model, List Message))
  , view : (model -> List output -> output)
  , actionDecoder : JDec.Decoder action
  , actionEncoder : (action -> JEnc.Value)
  , modelDecoder : JDec.Decoder model
  , modelEncoder : (model -> JEnc.Value)
  }

type Box output =  Box (Leaf output) (List (Int, Box output) ) 

toBox : BoxConfig action model output -> Box output
toBox boxCfg = 
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
      in 
        boxCfg.view model' children

    leaf =
    { init = boxCfg.modelEncoder boxCfg.init
    , next = decodedNext
    , view = view
    , toMessage = (\act -> Task.succeed ())  
    }
  in 
    Box leaf [] 


type Action = Own JEnc.Value | Child Int JEnc.Value

type alias App output =
  { output : Signal output 
  , msgs : Signal (Task () (List ()))  
  }

type alias SysEvent = ( (), ( Int, Int ), Char.KeyCode )

mouseAndKeyboard : Signal SysEvent
mouseAndKeyboard = 
  Signal.map3 (,,) Mouse.clicks Mouse.position Keyboard.presses

type SuperState = Local Int JEnc.Value (List SuperState)

toInit : (Int, Box output) -> SuperState
toInit (idx, (Box leaf children)) =
  case children of
    [] -> Local idx leaf.init []
    xs -> Local idx leaf.init (List.map toInit children)


start : Box output -> App output 
start (Box leaf children) =
  let 
    mailbox = Signal.mailbox (Own JEnc.null)
    
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
          ((Box leaf children), msgs)

    out = Signal.foldp next init mailbox.signal

    view (Box leaf children) = 
      case children of
        [] -> leaf.view leaf.init []
        xs -> leaf.view leaf.init (List.map view <| List.map snd children) 

  in 
    { output = Signal.map view <| Signal.map fst out
    , msgs = Signal.map (\(_, msgs)-> Task.sequence msgs) out
    }