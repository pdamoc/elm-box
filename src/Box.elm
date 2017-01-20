module Box exposing (Box, define)

{-| Helper to define pseudo-web-components

# Types
@docs Box

# Functions
@docs define
-}

import Native.Box
import Html exposing (Html)
import Json.Encode exposing (Value)
import Json.Decode exposing (Decoder)


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
    - `update` : similar to the regular update only that it also returns a
    Maybe ( String, Value ) that describes a potential event to be generated.
    The String is the name of the event, the Value is the payload.
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
    , update : msg -> model -> ( model, Cmd msg, Maybe ( String, Value ) )
    , subscriptions : model -> Sub msg
    , view : model -> Html msg
    , css : String
    }
    -> Box
define =
    Native.Box.define
