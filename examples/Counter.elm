module Counter where

import Box exposing (Box, BoxConfig, Message)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

import Json.Encode as JEnc
import Json.Decode as JDec exposing ( (:=), andThen)

type alias Model = Int

init : Model
init = 1

type Action = Increment | Decrement

next : Action -> Model -> (Model, List Message)
next action model = 
  case action of
    Increment -> (model+1, []) 
    Decrement -> (model-1, []) 

view : Signal.Address Action -> Model -> List Html -> Html
view address model children = 
    div []
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick address Increment ] [ text "+" ]
    ]

countStyle : Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]


modelDecoder : JDec.Decoder Model
modelDecoder = JDec.int 

modelEncoder : Int -> JEnc.Value
modelEncoder = JEnc.int 

actionDecoder : JDec.Decoder Action
actionDecoder = 
  let 
    infoDecode tag = 
      case tag of
        "Increment" -> JDec.succeed Increment
        "Decrement" -> JDec.succeed Decrement
        _ -> JDec.fail "Invalid Action"
  in 
    ("tag" := JDec.string) `andThen` infoDecode
    
actionEncoder : Action -> JEnc.Value
actionEncoder action = 
  case action of 
    Increment -> JEnc.object [("tag", JEnc.string "Increment")]
    Decrement -> JEnc.object [("tag", JEnc.string "Decrement")]


counter : Box.ActionAddress -> Box Html
counter = Box.toBox
  { init = init
  , next = next
  , view = view
  , actionDecoder = actionDecoder
  , actionEncoder = actionEncoder
  , modelDecoder = modelDecoder
  , modelEncoder = modelEncoder
  } []



main : Signal Html
main = .output <| Box.start counter