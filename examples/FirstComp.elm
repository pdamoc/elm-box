module FirstComp exposing (auxFirst)

import Html exposing (..)
import Box


component : component
component =
    Box.define
        { name = "aux-first"
        , css = """
        aux-first button {color: #f00 }
        """
        }


auxFirst : Html msg
auxFirst =
    node "aux-first" [] [ button [] [ text "click" ] ]
