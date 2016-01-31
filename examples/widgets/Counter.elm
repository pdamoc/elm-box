module Counter where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)

import Signal exposing (Message)

import Box exposing (Effects, noFx)


-- MODEL

type alias Model = Int

type alias ModelWithParent parentAction = 
  { model : Model 
  , onRemove : parentAction }

init : Int -> Model
init count = count

initWithAction : Int -> parentAction -> ModelWithParent parentAction
initWithAction count action = 
  (ModelWithParent (init count) action)

-- UPDATE

type Action = Increment | Decrement | Remove

update : Action -> Model -> Model
update action model =
  case action of
    Increment ->
      model + 1

    Decrement ->
      model - 1

    Remove -> model 

updateFx : Action -> ModelWithParent parentAction -> (ModelWithParent parentAction, (Effects Action, Effects parentAction))
updateFx action model =
  let 
    model' = { model | model = update action model.model }
  in 
    case action of 
      Remove -> (model', (noFx, Box.sendToParent model.onRemove))
      _ -> (model', (noFx, noFx))


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick address Increment ] [ text "+" ]
    ]

viewWithRemove : Signal.Address Action -> ModelWithParent action -> Html
viewWithRemove address model =
  div []
    [ button [ onClick address Decrement ] [ text "-" ]
    , div [ countStyle ] [ text (toString model.model) ]
    , button [ onClick address Increment ] [ text "+" ]
    , button [ onClick address Remove ] [text "⌫"]
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

type alias Counter a = Box.Config Model Action a
type alias CounterWithRemove a = Box.Config (ModelWithParent a) Action a

counter : Int -> (action -> parentAction) -> Counter parentAction
counter count toParentAction = 
  Box.simplebox (init count) update view

counterWithRemove : Int -> parentAction -> CounterWithRemove parentAction
counterWithRemove count onRemoveMessage = 
  Box.box (initWithAction count onRemoveMessage, noFx) updateFx viewWithRemove []

