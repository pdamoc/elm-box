import Html exposing (Html)
import Counter
import Box 

main : Signal Html
main = .html <| Box.start <| Counter.counter 0 Box.rootAction