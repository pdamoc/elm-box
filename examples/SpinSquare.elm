module SpinSquare exposing (spinSquare)

import Easing exposing (ease, easeOutBounce, float)
import Svg exposing (Svg, svg, rect, g, text, text_)
import Html exposing (Html, div, node)
import Svg.Attributes exposing (..)
import Svg.Events exposing (onClick)
import Time exposing (Time, second)
import AnimationFrame
import Box exposing (..)
import Json.Decode as Json


-- COMPONENT


boxName : String
boxName =
    "spin-square"


{-| Defines the box
-}
box : Box
box =
    Box.define
        { name = boxName
        , attributeDecoder = \_ _ -> Json.fail ""
        , init = \_ -> ( init, Cmd.none )
        , update = \m mdl -> ( update m mdl, Cmd.none, noEvent )
        , view = view
        , subscriptions = subscriptions
        , css = css
        }


css : String
css =
    """
spin-square div {
    display: inline-block;

}
"""


spinSquare : List (Html.Attribute msg) -> List (Html msg) -> Html msg
spinSquare =
    node boxName



-- MODEL


type alias Model =
    { angle : Float
    , prevClockTime : Time
    , elapsedTime : Maybe Time
    }


init : Model
init =
    { angle = 0
    , prevClockTime = 0
    , elapsedTime = Nothing
    }


rotateStep : number
rotateStep =
    90


duration : Time
duration =
    second



-- UPDATE


type Msg
    = Spin
    | Tick Time


update : Msg -> Model -> Model
update msg model =
    case msg of
        Spin ->
            case model.elapsedTime of
                Nothing ->
                    { model | elapsedTime = Just -1 }

                _ ->
                    model

        Tick clockTime ->
            case model.elapsedTime of
                Nothing ->
                    model

                Just -1 ->
                    { model | prevClockTime = clockTime, elapsedTime = Just 0 }

                _ ->
                    let
                        newElapsedTime =
                            clockTime - model.prevClockTime
                    in
                        if newElapsedTime > duration then
                            { model
                                | angle = model.angle + rotateStep
                                , elapsedTime = Nothing
                            }
                        else
                            { model
                                | angle = model.angle
                                , elapsedTime = Just newElapsedTime
                            }



-- VIEW


toOffset : Maybe Float -> Float
toOffset elapsedTime =
    case elapsedTime of
        Nothing ->
            0

        Just -1 ->
            0

        Just t ->
            ease easeOutBounce float 0 rotateStep duration t


view : Model -> Html Msg
view model =
    let
        angle =
            model.angle + toOffset model.elapsedTime
    in
        div []
            [ svg
                [ width "200", height "200", viewBox "0 0 200 200" ]
                [ g
                    [ transform ("translate(100, 100) rotate(" ++ toString angle ++ ")")
                    , onClick Spin
                    , cursor "pointer"
                    ]
                    [ rect
                        [ x "-50"
                        , y "-50"
                        , width "100"
                        , height "100"
                        , rx "15"
                        , ry "15"
                        , style "fill: #60B5CC;"
                        ]
                        []
                    , text_ [ fill "white", textAnchor "middle" ] [ text "Click me!" ]
                    ]
                ]
            ]


{-| There is a bug where if the model.elapsedTime is used to toggle the Ticks,
in the SpinSquarePair example, the second square is stopped by the first.
to reproduce, enable the second implementation (the one commented out) and in
SpinSquarePair example click first square and then quickly click the second.
The ending of the first square animation should freeze the second one midcycle
and make it unresponsive.
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    AnimationFrame.times Tick



--case model.elapsedTime of
--    Just _ ->
--        AnimationFrame.times Tick
--    Nothing ->
--        Sub.none


main : Svg msg
main =
    spinSquare [] []
