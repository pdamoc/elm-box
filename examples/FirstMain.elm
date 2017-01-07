module FirstMain exposing (..)

import Html exposing (Html, div, program)
import FirstComp exposing (..)


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
        [ auxFirst
        , auxFirst
        ]
