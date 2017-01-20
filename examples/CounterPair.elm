module CounterPair exposing (..)

import Html exposing (..)
import Counter exposing (counter, value)


main : Html msg
main =
    div []
        [ counter [ value 4 ] []
        , counter [ value 2 ] []
        ]
