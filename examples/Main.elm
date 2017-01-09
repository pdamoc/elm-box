module Main exposing (..)

import Html exposing (Html, div, program, text)
import LabeledInc exposing (..)


main : Program Never String Msg
main =
    program
        { init = ( "nothing set", Cmd.none )
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    String


type Msg
    = Inc Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Inc value ->
            ( toString value, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ labeledInc [ label "Counter: ", onInc Inc ] []
        , div [] [ text model ]
        ]
