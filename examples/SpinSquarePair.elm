module SpinSquarePair exposing (..)

import Html exposing (..)
import SpinSquare exposing (spinSquare)


main : Html msg
main =
    div []
        [ spinSquare [] []
        , spinSquare [] []
        ]
