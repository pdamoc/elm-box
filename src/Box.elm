module Box exposing (Component, define)

{-| Utility functions to define your own Web Components in Elm.

# Types
@docs Component

# Functions
@docs define
-}

import Native.Box
import Html exposing (Html)
import Json.Encode exposing (Value)
import Json.Decode exposing (Decoder)


--


{-| Opaque Component type
-}
type Component
    = Component


{-| Define a Component

This definition has the side effect of registering the component
-}
define :
    { name : String
    , init : List ( String, String ) -> ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg, Maybe ( String, Value ) )
    , subscriptions : model -> Sub msg
    , input : String -> String -> Decoder msg
    , view : model -> Html msg
    , css : String
    }
    -> Component
define =
    Native.Box.define
