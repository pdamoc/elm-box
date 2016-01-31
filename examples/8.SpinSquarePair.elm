module SpinSquarePair where

import Html exposing (..)
import Html.Attributes exposing (..)
import SpinSquare

import Box exposing (rootAction, Effects, batchFx)

-- MODEL

type alias Model =
    { left : SpinSquare.SpinSquare Action
    , right : SpinSquare.SpinSquare Action
    }


init : (Model, Effects Action)
init =
  let
    (left, leftFx) = SpinSquare.spinSquare Left
    (right, rightFx) = SpinSquare.spinSquare Right
  in
    ( Model left right, batchFx [ leftFx, rightFx ])


-- UPDATE

type Action
    = Left SpinSquare.Action
    | Right SpinSquare.Action


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
        ( Model model.left right, fx)



-- VIEW

(=>) : a -> b -> ( a, b )
(=>) = (,)


view : Signal.Address Action -> Model -> Html
view address model =
  div [ style [ "display" => "flex" ] ]
    [ Box.viewChild address Left model.left
    , Box.viewChild address Right model.right
    ]

type alias SpinSquarePair a = Box.Config Model Action a

spinSquarePair : (Action -> parentAction) -> SpinSquarePair parentAction
spinSquarePair toParentAction = 
  Box.box init (Box.withParentFx toParentAction update) view []


-- MAIN WIRING 

app : Box.App Model
app = Box.start <| spinSquarePair Box.rootAction

main : Signal Html 
main = app.html 

port tasks : Box.Tasks
port tasks = app.tasks