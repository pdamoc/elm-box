module CounterPair where

import Counter
import Html exposing (..)
import Html.Events exposing (..)
import Box 


-- MODEL

type alias Model =
    { topCounter : Counter.Counter Action
    , bottomCounter : Counter.Counter Action
    }

init : Int -> Int -> Model
init top bottom =
    { topCounter = Counter.counter top Top
    , bottomCounter = Counter.counter bottom Bottom
    }


-- UPDATE

type Action
    = Reset
    | Top Counter.Action
    | Bottom Counter.Action


update : Action -> Model -> Model
update action model =
  case action of
    Reset -> init 0 0

    Top act ->
      { model |
          topCounter = Box.noFxUpdate act model.topCounter
      }

    Bottom act ->
      { model |
          bottomCounter = Box.noFxUpdate act model.bottomCounter
      }


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ Box.viewChild address Top model.topCounter
    , Box.viewChild address Bottom model.bottomCounter
    , button [ onClick address Reset ] [ text "RESET" ]
    ]

type alias CounterPair a = Box.Config Model Action a

counterPair : Int -> Int -> (Action -> parentAction) -> CounterPair parentAction
counterPair top bottom toParentAction =
  Box.simplebox (init top bottom) update view


-- MAIN WIRING 

main : Signal Html
main = .html <| Box.start <| counterPair 0 0 Box.rootAction