module First exposing (..)

import Html exposing (..)
import Box


myComp =
    Box.define
        { name = "x-hello"
        , css = """
        x-hello button {color: #f00 }
        """
        }


xHello =
    node "x-hello" [] [ button [] [ text "click" ] ]


main : Html msg
main =
    xHello
