module LabeledInc exposing (labeledInc, label, onInc)

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
        , init = ( Model 0 "Count: ", Cmd.none )
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , input = input
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


{-| Event for when the component increments
-}
onInc : (Int -> msg) -> Attribute msg
onInc tagger =
    on "inc" (Json.map tagger (Json.field "value" Json.int))


{-| a decoder that helps feed the arguments back into the component as messages
-}
input : String -> String -> Decoder Msg
input name value =
    case name of
        "aux-label" ->
            Json.succeed (UpdateLabel value)

        _ ->
            Json.fail "unknown attribute"



-- IMPLEMENTATION


type alias Model =
    { value : Int
    , label : String
    }


type Msg
    = Click
    | UpdateLabel String


update : Msg -> Model -> ( Model, Cmd msg, Maybe ( String, Value ) )
update msg model =
    case Debug.log "LabeledInc:" msg of
        Click ->
            ( { model | value = model.value + 1 }, Cmd.none, Just ( "inc", JE.int (model.value + 1) ) )

        UpdateLabel label ->
            ( { model | label = label }, Cmd.none, Nothing )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Click ] [ text (model.label ++ (toString model.value)) ]
        ]
