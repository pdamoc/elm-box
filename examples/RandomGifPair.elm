module RandomGifPair exposing (..)

import Html exposing (..)
import RandomGif exposing (randomGif, topic)


main : Html msg
main =
    div []
        [ randomGif [ topic "cats" ] []
        , randomGif [ topic "dogs" ] []
        ]
