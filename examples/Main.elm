module Main exposing (..)

import Html exposing (Html, div, program)
import LabeledInc


main : Program Never Int Msg
main =
    program
        { init = ( 0, Cmd.none )
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    Int


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view : Model -> Html msg
view model =
    div []
        [ LabeledInc.labeledInc [ LabeledInc.label "Counter: " ] []
        ]
