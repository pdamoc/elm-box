import Counter 
import Box
import Html exposing (Html)

main : Signal Html
main = .output <| Box.start Counter.counter