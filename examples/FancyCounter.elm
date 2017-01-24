module FancyCounter exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, style)
import Html.Events exposing (..)
import Box exposing (..)
import Json.Encode as JE exposing (Value)
import Json.Decode as Json exposing (Decoder)
import List.Extra exposing (singleton)
import Css exposing (..)
import Css.Elements


-- WIRING


boxName : String
boxName =
    "elm-fancy-counter"


{-| Defines the box
-}
counter : List (Attribute msg) -> List (Html msg) -> Html msg
counter =
    Box.box
        { name = boxName
        , attributeDecoder = attributeDecoder
        , init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , css = css
        }



-- STYLE DEFINITION


{-| helper to convert a list of definitions to a set of rules local to the box
-}
localCss : List Snippet -> String
localCss =
    .css
        << compile
        << singleton
        << stylesheet
        << singleton
        << selector boxName
        << singleton
        << descendants


type CssClasses
    = Label
    | Container


myClass : CssClasses -> Attribute msg
myClass =
    class << toString


css : String
css =
    localCss
        [ (.) Label
            [ fontSize (px 20)
            , fontFamily monospace
            , display inlineBlock
            , width (px 50)
            , textAlign center
            ]
        , (.) Container
            [ padding (px 5)
            , margin (px 5)
            , borderRadius (px 8)
            , border3 (px 1) solid (hex "CCC")
            , backgroundColor (hex "EEE")
            , property "display" "inline-flex"
            , flexDirection row
            ]
        , Css.Elements.button
            [ margin (px 5) ]
        ]



-- INTERFACE FOR THE COMPONENT


{-| attribute for setting the value of the counter
-}
value : Int -> Attribute msg
value val =
    attribute "value" (toString val)


{-| Event for when the counter updates
-}
onCounterUpdate : (Int -> msg) -> Attribute msg
onCounterUpdate tagger =
    on "counter-update" (Json.map tagger (Json.field "value" Json.int))


{-| a decoder that helps feed the arguments back into the component as messages
-}
attributeDecoder : String -> String -> Decoder Msg
attributeDecoder name value =
    case name of
        "value" ->
            case Json.decodeString Json.int value of
                Ok val ->
                    Json.succeed (UpdateValue val)

                Err _ ->
                    Json.fail "invalid value"

        _ ->
            Json.fail "unknown attribute"



-- IMPLEMENTATION


type alias Model =
    Int


init : List Msg -> ( Model, Cmd Msg )
init attrs =
    let
        updateAttributes msg ( model, cmds ) =
            update msg model
    in
        List.foldr updateAttributes ( 0, Cmd.none ) attrs


type Msg
    = Increment
    | Decrement
    | UpdateValue Int


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Increment ->
            update (UpdateValue (model + 1)) model

        Decrement ->
            update (UpdateValue (model - 1)) model

        UpdateValue val ->
            if model == val then
                ( model, Cmd.none )
            else
                ( val, event "counter-update" (JE.int val) )


view : Model -> Html Msg
view model =
    div [ myClass Container ]
        [ button [ onClick Decrement ] [ Html.text "-" ]
        , div [ myClass Label ] [ Html.text (toString model) ]
        , button [ onClick Increment ] [ Html.text "+" ]
        ]


main : Html msg
main =
    counter [] []
