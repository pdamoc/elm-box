module SimpleBox exposing (..)

import Html exposing (node, div, button, h1, text)
import Html.Events exposing (onClick)
import Box exposing (defineSimple)


box =
    defineSimple { name = "simple-box", model = 0, view = view, update = update }


main =
    node "simple-box" [] []


view model =
    div []
        [ button [ onClick Increment ] [ text "Click me" ]
        , h1 [] [ text (toString model) ]
        ]


type Msg
    = Increment


update msg model =
    case msg of
        Increment ->
            model + 1
