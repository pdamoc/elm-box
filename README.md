# THIS CODE IS EXPERIMENTAL


# To play 

    git clone https://github.com/pdamoc/elm-box.git
    cd elm-box/examples
    elm-package install -y
    python patchCore.py
    elm-reactor

navigate to [http://localhost:8000/](http://localhost:8000/)

The examples show how to create boxes and how to compose them in your elm apps. 

The `patchCore.py` is a temporary measure. It simply adds a few lines that exposes private functions needed by the implementation. Two files are affected: `Platform.js` and `VirtualDom.js`.  

# To use in a test project 

Install  `elm-github-install` using `npm install elm-github-install -g` (if you don't have it).

Download [patchCore.py](https://raw.githubusercontent.com/pdamoc/elm-box/master/examples/patchCore.py).

Add to your `elm-package.json` the following dependency 

    "pdamoc/elm-box": "1.0.0 <= v < 2.0.0"

And run the following: 
    
    elm-github-install
    python patchCore.py

You're now all set! :) 

# Simple Example

```elm
module SimpleBox exposing (..)

import Html exposing (node, div, button, h1, text)
import Html.Events exposing (onClick)
import Box exposing (simpleBox)


main =
    simpleBox { name = "simple-box", model = 0, view = view, update = update } [] []


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

```
# Simple example for Box.styled

```elm
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

```

# Full Example 


```elm
module Counter exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, style)
import Html.Events exposing (..)
import Box exposing (..)
import Json.Encode as JE exposing (Value)
import Json.Decode as Json exposing (Decoder)


-- WIRING


boxName : String
boxName =
    "elm-counter"


{-| Defines the counter
-}
counter : List (Attribute msg) -> List (Html msg) -> Html msg
counter =
    Box.box
        { name = boxName
        , attributeDecoder = attributeDecoder
        , init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , css = css
        }


css : String
css =
    """
elm-counter .label {
    font-size: 20px;
    font-family: monospace;
    display: inline-block;
    width: 50px;
    text-align: center;
}
elm-counter .container {
    padding: 5px;
    margin: 5px;
    border-radius: 16px!important;
    border: 1px solid #ccc!important;
    background-color: #eee;
    display: inline-flex;
    flex-direction: row;
}
elm-counter button {
    margin: 5px;
}

"""



-- INTERFACE FOR THE COMPONENT


{-| attribute for setting the value of the counter
-}
value : Int -> Attribute msg
value val =
    attribute "value" (toString val)


{-| Event for when the counter updates
-}
onCounterUpdate : (Int -> msg) -> Attribute msg
onCounterUpdate tagger =
    on "counter-update" (Json.map tagger (Json.field "value" Json.int))


{-| a decoder that helps feed the arguments back into the component as messages
-}
attributeDecoder : String -> String -> Decoder Msg
attributeDecoder name value =
    case name of
        "value" ->
            case Json.decodeString Json.int value of
                Ok val ->
                    Json.succeed (UpdateValue val)

                Err _ ->
                    Json.fail "invalid value"

        _ ->
            Json.fail "unknown attribute"



-- IMPLEMENTATION


type alias Model =
    Int


init : List Msg -> ( Model, Cmd Msg )
init attrs =
    let
        updateAttributes msg ( model, cmds ) =
            update msg model
    in
        List.foldr updateAttributes ( 0, Cmd.none ) attrs


type Msg
    = Increment
    | Decrement
    | UpdateValue Int


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Increment ->
            update (UpdateValue (model + 1)) model

        Decrement ->
            update (UpdateValue (model - 1)) model

        UpdateValue val ->
            if model == val then
                ( model, Cmd.none )
            else
                ( val, event "counter-update" (JE.int val) )


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ button [ onClick Decrement ] [ text "-" ]
        , div [ class "label" ] [ text (toString model) ]
        , button [ onClick Increment ] [ text "+" ]
        ]


main : Html msg
main =
    counter [ value 5 ] []

```

# Fancy Example that uses elm-css

```elm 
module FancyCounter exposing (..)

import Html exposing (..)
import Html.Attributes exposing (attribute, class, style)
import Html.Events exposing (..)
import Box exposing (..)
import Json.Encode as JE exposing (Value)
import Json.Decode as Json exposing (Decoder)
import List.Extra exposing (singleton)
import Css exposing (..)
import Css.Elements


-- WIRING


boxName : String
boxName =
    "elm-fancy-counter"


{-| Defines the box
-}
counter : List (Attribute msg) -> List (Html msg) -> Html msg
counter =
    Box.box
        { name = boxName
        , attributeDecoder = attributeDecoder
        , init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , css = css
        }



-- STYLE DEFINITION


{-| helper to convert a list of definitions to a set of rules local to the box
-}
localCss : List Snippet -> String
localCss =
    .css
        << compile
        << singleton
        << stylesheet
        << singleton
        << selector boxName
        << singleton
        << descendants


type CssClasses
    = Label
    | Container


myClass : CssClasses -> Attribute msg
myClass =
    class << toString


css : String
css =
    localCss
        [ (.) Label
            [ fontSize (px 20)
            , fontFamily monospace
            , display inlineBlock
            , width (px 50)
            , textAlign center
            ]
        , (.) Container
            [ padding (px 5)
            , margin (px 5)
            , borderRadius (px 8)
            , border3 (px 1) solid (hex "CCC")
            , backgroundColor (hex "EEE")
            , property "display" "inline-flex"
            , flexDirection row
            ]
        , Css.Elements.button
            [ margin (px 5) ]
        ]



-- INTERFACE FOR THE COMPONENT


{-| attribute for setting the value of the counter
-}
value : Int -> Attribute msg
value val =
    attribute "value" (toString val)


{-| Event for when the counter updates
-}
onCounterUpdate : (Int -> msg) -> Attribute msg
onCounterUpdate tagger =
    on "counter-update" (Json.map tagger (Json.field "value" Json.int))


{-| a decoder that helps feed the arguments back into the component as messages
-}
attributeDecoder : String -> String -> Decoder Msg
attributeDecoder name value =
    case name of
        "value" ->
            case Json.decodeString Json.int value of
                Ok val ->
                    Json.succeed (UpdateValue val)

                Err _ ->
                    Json.fail "invalid value"

        _ ->
            Json.fail "unknown attribute"



-- IMPLEMENTATION


type alias Model =
    Int


init : List Msg -> ( Model, Cmd Msg )
init attrs =
    let
        updateAttributes msg ( model, cmds ) =
            update msg model
    in
        List.foldr updateAttributes ( 0, Cmd.none ) attrs


type Msg
    = Increment
    | Decrement
    | UpdateValue Int


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Increment ->
            update (UpdateValue (model + 1)) model

        Decrement ->
            update (UpdateValue (model - 1)) model

        UpdateValue val ->
            if model == val then
                ( model, Cmd.none )
            else
                ( val, event "counter-update" (JE.int val) )


view : Model -> Html Msg
view model =
    div [ myClass Container ]
        [ button [ onClick Decrement ] [ Html.text "-" ]
        , div [ myClass Label ] [ Html.text (toString model) ]
        , button [ onClick Increment ] [ Html.text "+" ]
        ]


main : Html msg
main =
    counter [] []
```