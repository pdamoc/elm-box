module CounterPairList where

import CounterPair
import Html exposing (..)
import Html.Events exposing (..)
import Box exposing (ID, nextId)


-- MODEL

type alias Model = List (ID, CounterPair.CounterPair Action)

init : Model
init = []


-- UPDATE

type Action
    = Insert
    | Remove
    | Modify ID CounterPair.Action


update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      model ++ [(nextId model,  CounterPair.counterPair 0 0 (Modify 0))]

    Remove ->
      List.drop 1 model

    Modify id counterAction ->
      Box.updateChildrenNoFx Modify id counterAction model

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let counters = Box.viewChildren address Modify model
      remove = button [ onClick address Remove ] [ text "Remove" ]
      insert = button [ onClick address Insert ] [ text "Add" ]
  in
      div [] ([remove, insert] ++ counters)


type alias CounterList = Box.Config Model Action Box.RootAction

counterPairList : CounterList
counterPairList = Box.simplebox init update view


-- MAIN WIRING

main : Signal Html
main = .html <| Box.start <| counterPairList
