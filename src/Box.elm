module Box exposing (box, simpleBox, styled, event)

{-| Helper to define pseudo-web-components

# Functions
@docs box, simpleBox, event, styled
-}

import Native.Box
import Html exposing (Html, Attribute)
import Json.Encode exposing (Value)
import Json.Decode exposing (Decoder, fail)


--


{-| Define a Box

This definition has the side effect of registering the `custom element`

The fiels are:
    - `name` : the name of the `custom element`. The name MUST contain a hyphen! (e.g. "my-app")
    - `attributeDecoder` : a function that receives a name and a value for the attributes
     that have been given or have been updated and returns a decoder that converts
     the values into a message that the `custom element` will receive in its `update`.
    - `init` : a function that receives a list with all the messages obtained from
    decoding the attributes with the `attributeDecoder` and returns the initial
    model and Cmd (just like in the regular TEA `init`).
    - `update` : standard TEA `update` . Use Box.event to generate events.
    - `subscription`: standard TEA `subscription`
    - `view`: standard TEA `view`
    - `css` : a String containing the CSS for the `custom element`. Please make sure to
    use the `name` of the `custom element` as a selector for each internal rule.
    (e.g. "my-app button { color: #f00 }")
-}
box :
    { name : String
    , attributeDecoder : String -> String -> Decoder innerMsg
    , init : List innerMsg -> ( model, Cmd innerMsg )
    , update : innerMsg -> model -> ( model, Cmd innerMsg )
    , subscriptions : model -> Sub innerMsg
    , view : model -> Html innerMsg
    , css : String
    }
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
box =
    Native.Box.box


{-| Define a Simple Box

equivalent to beginnerProgram
-}
simpleBox :
    { name : String
    , model : model
    , update : innerMsg -> model -> model
    , view : model -> Html innerMsg
    }
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
simpleBox impl =
    box
        { name = impl.name
        , attributeDecoder = \_ _ -> fail ""
        , init = \_ -> ( impl.model, Cmd.none )
        , update = \m mdl -> ( impl.update m mdl, Cmd.none )
        , subscriptions = \_ -> Sub.none
        , view = impl.view
        , css = ""
        }


{-| Receives the name of the event and a payload. It will generate an event
with the provided name where the payload is in the `value` property of the event.
-}
event : String -> Value -> Cmd msg
event =
    Native.Box.event


{-| create a new element by adding CSS to an base tag.
First parameter is the name of the new element, second is the base (e.g. Button)
and the third is the syles as String properly selected with the name

    redH1 = styled "red-h1" "Heading" "red-h1 {color: red; display: block; font-size: 2em; margin-top: 0.67em; margin-bottom: 0.67em; margin-left: 0; margin-right: 0;font-weight: bold;}"

-}
styled : String -> String -> String -> List (Attribute msg) -> List (Html msg) -> Html msg
styled =
    Native.Box.styled
