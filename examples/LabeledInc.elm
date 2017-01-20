module LabeledInc exposing (labeledInc, label, value, onInc)

import Html exposing (..)
import Html.Attributes exposing (attribute, name)
import Html.Events exposing (..)
import Box exposing (Component)
import Json.Encode as JE exposing (Value)
import Json.Decode as Json exposing (Decoder)


-- WIRING


{-| Defines the component
-}
component : Component
component =
    Box.define
        { name = "aux-labeled-inc"
        , attributeDecoder = attributeDecoder
        , init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , css = """
        aux-labeled-inc button {color: #f00 }
        """
        }



-- INTERFACE FOR THE COMPONENT


{-| the Html node that ends up being used
-}
labeledInc : List (Attribute msg) -> List (Html msg) -> Html msg
labeledInc =
    node "aux-labeled-inc"


{-| attribute for setting the label of the component
-}
label : String -> Attribute msg
label =
    attribute "aux-label"


{-| attribute for setting the value of the component
-}
value : Int -> Attribute msg
value val =
    attribute "value" (toString val)


{-| Event for when the component increments
-}
onInc : (Int -> msg) -> Attribute msg
onInc tagger =
    on "inc" (Json.map tagger (Json.field "value" Json.int))


{-| a decoder that helps feed the arguments back into the component as messages
-}
attributeDecoder : String -> String -> Decoder Msg
attributeDecoder name value =
    case name of
        "aux-label" ->
            Json.succeed (UpdateLabel value)

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
    { value : Int
    , label : String
    }


init : List Msg -> ( Model, Cmd Msg )
init attrs =
    let
        updateAttributes msg ( model, cmds ) =
            let
                ( newModel, cmd, _ ) =
                    update msg model
            in
                ( newModel, cmd )
    in
        List.foldr updateAttributes ( Model 0 "Count: ", Cmd.none ) attrs


type Msg
    = Click
    | UpdateLabel String
    | UpdateValue Int


update : Msg -> Model -> ( Model, Cmd msg, Maybe ( String, Value ) )
update msg model =
    case Debug.log "LabeledInc:" msg of
        Click ->
            ( { model | value = model.value + 1 }, Cmd.none, Just ( "inc", JE.int (model.value + 1) ) )

        UpdateLabel label ->
            ( { model | label = label }, Cmd.none, Nothing )

        UpdateValue val ->
            ( { model | value = val }, Cmd.none, Nothing )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Click ] [ text (model.label ++ (toString model.value)) ]
        ]


main : Html msg
main =
    labeledInc [] []
