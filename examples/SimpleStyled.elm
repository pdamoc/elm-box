module SimpleStyled exposing (..)

import Html exposing (div, text)
import Html.Attributes exposing (attribute)
import Box


simpleStyled =
    Box.styled "simple-styled" "Span" css


disabled =
    attribute "disabled" "true"


css =
    """
simple-styled {
    color : red;
}

simple-styled[disabled=true] {
    color : #eee;
}
"""


main =
    div []
        [ simpleStyled [] [ text "Hello enabled" ]
        , div [] [ simpleStyled [ disabled ] [ text "Hello disabled" ] ]
        ]
