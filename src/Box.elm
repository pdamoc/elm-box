module Box exposing (Component, define)

{-| Utility functions to define your own Web Components in Elm.

# Types
@docs Component

# Functions
@docs define
-}

import Native.Box
import Html exposing (Html)


{-| Opaque Component type
-}
type Component
    = Component


{-| Define a Component

This definition has the side effect of registering the component
-}
define :
    { name : String
    , init : ( model, Cmd msg )
    , update : msg -> model -> ( model, Cmd msg )
    , subscriptions : model -> Sub msg
    , view : model -> Html msg
    , css : String
    }
    -> Component
define =
    Native.Box.define
