module SimpleGrid exposing (..)

import Html exposing (div, text)
import Html.Attributes exposing (attribute)
import Box


row =
    Box.styled "box-row" "Div" css


col =
    Box.styled "box-col" "Div" css


grow =
    attribute "grow" ""


third =
    attribute "third" ""


dark =
    attribute "dark" ""


css =
    """
box-row {
    display: flex;
    justify-content: space-between;
}

box-row box-col {
    text-align : center;
}

box-row box-col[grow]  {
    flex: 1;
}

box-row box-col[third] {
    width: 32%;
    background: #eee;
}

box-row box-col[dark] {
    background : #333;
    color : #fff;
}
"""


main =
    div []
        [ row []
            [ col [ dark, grow ] [ text "fullwidth" ] ]
        , row []
            [ col [ third ] [ text "First" ]
            , col [ third ] [ text "Second" ]
            , col [ third ] [ text "Last" ]
            ]
        ]
