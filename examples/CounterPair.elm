import Html exposing (Html)
import Box exposing (Box)

import Counter exposing (counter)


counterPair : Box Html
counterPair = 
  Box.vBox 
    [ counter [] 
    , counter [] 
    ]

main : Signal Html
main = .output <| Box.start counterPair