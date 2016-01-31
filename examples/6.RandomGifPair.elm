module RandomGifPair where

import Html exposing (..)
import Html.Attributes exposing (..)

import RandomGif
import Box exposing (Effects, batchFx)

-- MODEL

type alias Model =
    { left : RandomGif.RandomGif Action
    , right : RandomGif.RandomGif Action
    }


init : String -> String -> (Model, Effects Action)
init leftTopic rightTopic =
  let
    (left, leftFx) = RandomGif.randomGif leftTopic Left
    (right, rightFx) = RandomGif.randomGif rightTopic Left
  in
    ( Model left right, batchFx [leftFx, rightFx])


-- UPDATE

type Action
    = Left RandomGif.Action
    | Right RandomGif.Action


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Left act ->  
      let
        (left, fx) = Box.updateChild Left act model.left
      in
        ( Model left model.right, fx)

    Right act ->
      
      let
        (right, fx) = Box.updateChild Right act model.right
      in
        ( Model model.left right, fx )


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div [ style [ ("display", "flex") ] ]
    [ Box.viewChild address Left model.left
    , Box.viewChild address Right model.right
    ]



type alias RandomGifPair a = Box.Config Model Action a

randomGifPair : String -> String -> (Action -> parentAction) -> RandomGifPair parentAction
randomGifPair leftTopic rightTopic toParentAction = 
  Box.box (init leftTopic rightTopic) (Box.withParentFx toParentAction update) view []


-- MAIN WIRING 

app : Box.App Model
app = Box.start <| randomGifPair "funny cats" "funny dogs" Box.rootAction 

main : Signal Html
main = app.html 

port tasks : Box.Tasks
port tasks = app.tasks