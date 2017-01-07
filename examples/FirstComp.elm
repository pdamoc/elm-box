module FirstComp exposing (auxFirst)

import Html exposing (..)
import Html.Events exposing (..)
import Box


component : component
component =
    Box.define
        { name = "aux-first"
        , init = ( 0, Cmd.none )
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


type Msg
    = Click


update msg model =
    case Debug.log "msg:" msg of
        Click ->
            ( model + 1, Cmd.none )


view model =
    div []
        [ button [ onClick Click ] [ text ("Inside Elm: " ++ (toString model)) ]
        ]
