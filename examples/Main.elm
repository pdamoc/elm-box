module Main exposing (..)

import Html exposing (Html, div, program, text, br, button)
import Html.Events exposing (onClick)
import LabeledInc exposing (..)
import RandomGif exposing (..)


main : Program Never Model Msg
main =
    program
        { init = ( Model 0 0 "dogs", Cmd.none )
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { inc1 : Int
    , inc2 : Int
    , topic : String
    }


type Msg
    = IncOne Int
    | IncTwo Int
    | SetTopic String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IncOne value ->
            ( { model | inc1 = value }, Cmd.none )

        IncTwo value ->
            ( { model | inc2 = value }, Cmd.none )

        SetTopic topic ->
            ( { model | topic = topic }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ labeledInc [ label "Counter: ", onInc IncOne ] []
        , div [] [ text (toString model.inc1) ]
        , br [] []
        , labeledInc [ label "Counter: ", onInc IncTwo ] []
        , div [] [ text (toString model.inc2) ]
        , br [] []
        , div []
            [ button [ onClick (SetTopic "dogs") ] [ text "Dogs" ]
            , button [ onClick (SetTopic "sloths") ] [ text "Sloths" ]
            , button [ onClick (SetTopic "cats") ] [ text "Cats" ]
            ]
        , randomGif [ topic model.topic ] []
        ]
