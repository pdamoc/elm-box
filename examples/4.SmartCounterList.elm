module SmartCounterList where

import Counter exposing (counterWithRemove)
import Html exposing (..)
import Html.Events exposing (..)
import Box exposing (Effects, noFx, ID)


-- MODEL

type alias Model = List (ID, Counter.CounterWithRemove Action)

init : Model
init = []


-- UPDATE

type Action
    = Insert
    | Remove ID
    | Modify ID Counter.Action

remove : Int -> List a -> List a
remove idx xs = 
  case xs of 
    [] -> []
    x::[] -> []
    _ -> (List.take idx xs) ++ (List.drop (idx+1) xs)

update : Action -> Model -> (Model, Effects Action) 
update action model =
  case action of
    Insert ->
      let 
        id = Box.nextId model
        newCounter = (counterWithRemove 0 (Remove id) )
      in 
        ( model ++ [(id, newCounter)], noFx )

    Remove id ->
      (List.filter (\(idx, _)-> not (id == idx)) model, noFx) 

    Modify id counterAction ->
      Box.updateChildren Modify id counterAction model


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let 
    insert = button [ onClick address Insert ] [ text "Add" ]
  in
    div [] (insert :: (Box.viewChildren address Modify model))


type alias CounterList a = Box.Config Model Action a

counterList : (Action ->parentAction)-> CounterList parentAction
counterList toParentAction = 
  Box.box (init, noFx) (Box.withParentFx toParentAction update) view []


-- MAIN WIRING 

app : Box.App Model
app = Box.start <| counterList Box.rootAction

main : Signal Html
main = app.html 

port tasks : Box.Tasks
port tasks = app.tasks

