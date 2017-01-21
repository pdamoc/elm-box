module Box exposing (Box, define, defineSimple, event)

{-| Helper to define pseudo-web-components

# Types
@docs Box

# Functions
@docs define, defineSimple, event
-}

import Native.Box
import Html exposing (Html)
import Json.Encode exposing (Value)
import Json.Decode exposing (Decoder, fail)


--


{-| Opaque Box type
-}
type Box
    = Box


{-| Define a Box

This definition has the side effect of registering the `custom element`

The fiels are:
    - `name` : the name of the `custom element`.
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
    (e.g. "my-app button { color: #f00 }" where "my-app" is the `name`)
-}
define :
    { name : String
    , attributeDecoder : String -> String -> Decoder msg
    , init : List msg -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    , view : model -> Html msg
    , css : String
    }
    -> Box
define =
    Native.Box.define


{-| Define a Simple Box

equivalent to beginnerProgram
-}
defineSimple :
    { name : String
    , model : model
    , update : msg -> model -> model
    , view : model -> Html msg
    }
    -> Box
defineSimple impl =
    define
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
