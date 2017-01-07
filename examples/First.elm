module First exposing (..)

import Html exposing (..)
import Box


myComp =
    Box.define { name = "x-hello", init = 0 }


xHello =
    node "x-hello" [] [ button [] [ text "click" ] ]


main : Html msg
main =
    xHello
