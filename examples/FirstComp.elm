module FirstComp exposing (auxFirst)

import Html exposing (..)
import Html.Events exposing (..)
import Box exposing (Component)


component : Component
component =
    Box.define
        { name = "aux-first"
        , init = ( Model 0 "Count: ", Cmd.none )
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , css = """
        aux-first button {color: #f00 }
        """
        }


auxFirst : Html msg
auxFirst =
    node "aux-first" [] []


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
