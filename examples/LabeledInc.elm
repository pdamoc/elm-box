module LabeledInc exposing (labeledInc, label, onInc)

import Html exposing (..)
import Html.Attributes exposing (attribute, name)
import Html.Events exposing (..)
import Box exposing (Component)


-- WIRING


component : Component
component =
    Box.define
        { name = "aux-labeled-inc"
        , init = ( Model 0 "Count: ", Cmd.none )
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , css = """
        aux-labeled-inc button {color: #f00 }
        """
        }



-- INTERFACE


labeledInc : List (Attribute msg) -> List (Html msg) -> Html msg
labeledInc =
    node "aux-labeled-inc"


label : String -> Attribute msg
label =
    attribute "aux-label"


onInc : (Int -> msg) -> Attribute msg
onInc tagger =
    name "tmp"



-- placehoder for future code
-- IMPLEMENTATION


type alias Model =
    { value : Int
    , label : String
    }


type Msg
    = Click
    | UpdateLabel String


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case Debug.log "msg:" msg of
        Click ->
            ( { model | value = model.value + 1 }, Cmd.none )

        UpdateLabel label ->
            ( { model | label = label }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Click ] [ text (model.label ++ (toString model.value)) ]
        ]
