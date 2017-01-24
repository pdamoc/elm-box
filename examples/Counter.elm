module Counter exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, style)
import Html.Events exposing (..)
import Box exposing (..)
import Json.Encode as JE exposing (Value)
import Json.Decode as Json exposing (Decoder)


-- WIRING


boxName : String
boxName =
    "elm-counter"


{-| Defines the counter
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


css : String
css =
    """
elm-counter .label {
    font-size: 20px;
    font-family: monospace;
    display: inline-block;
    width: 50px;
    text-align: center;
}
elm-counter .container {
    padding: 5px;
    margin: 5px;
    border-radius: 16px!important;
    border: 1px solid #ccc!important;
    background-color: #eee;
    display: inline-flex;
    flex-direction: row;
}
elm-counter button {
    margin: 5px;
}

"""



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
    div [ class "container" ]
        [ button [ onClick Decrement ] [ text "-" ]
        , div [ class "label" ] [ text (toString model) ]
        , button [ onClick Increment ] [ text "+" ]
        ]


main : Html msg
main =
    counter [ value 5 ] []
