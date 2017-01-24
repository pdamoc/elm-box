module Heretic exposing (..)

import Html exposing (Html, div, program, text, br, button)
import Html.Attributes exposing (id)
import Html.Events exposing (onClick)
import LabeledInc exposing (..)
import RandomGif exposing (..)
import Json.Decode as Json exposing (Decoder)
import Box exposing (..)


name : String
name =
    "main-app"


{-| Defines the box
-}
main : Html msg
main =
    Box.box
        { name = name
        , attributeDecoder = attributeDecoder
        , init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , css = """
        #blue button {color: #00f }
        """
        }
        []
        []


{-| a decoder that helps feed the arguments back into the box as messages
-}
attributeDecoder : String -> String -> Decoder Msg
attributeDecoder name value =
    case name of
        "topic" ->
            Json.succeed (SetTopic value)

        "inc1" ->
            let
                intVal =
                    String.toInt value
            in
                case intVal of
                    Ok val ->
                        Json.succeed (IncOne val)

                    Err _ ->
                        Json.fail "bad number"

        "inc2" ->
            let
                intVal =
                    String.toInt value
            in
                case intVal of
                    Ok val ->
                        Json.succeed (IncTwo val)

                    Err _ ->
                        Json.fail "bad number"

        _ ->
            Json.fail "unknown attribute"


type alias Model =
    { inc1 : Int
    , inc2 : Int
    , topic : String
    }


init : List Msg -> ( Model, Cmd Msg )
init attrs =
    let
        updateAttributes msg ( model, cmds ) =
            update msg model
    in
        List.foldr updateAttributes ( Model 0 0 "dogs", Cmd.none ) attrs


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
        [ labeledInc [ label "CounterOne: ", onInc IncOne, value model.inc1 ] []
        , div [] [ text (toString model.inc1) ]
        , br [] []
        , labeledInc [ label "CounterTwo: ", onInc IncTwo, value model.inc2, id "blue" ] []
        , div [] [ text (toString model.inc2) ]
        , br [] []
        , div []
            [ button [ onClick (SetTopic "dogs") ] [ text "Dogs" ]
            , button [ onClick (SetTopic "sloths") ] [ text "Sloths" ]
            , button [ onClick (SetTopic "cats") ] [ text "Cats" ]
            ]
        , randomGif [ topic model.topic ] []
        ]
