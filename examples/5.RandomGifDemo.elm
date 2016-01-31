import Html exposing (Html)
import RandomGif exposing (randomGif)
import Box 

app : Box.App RandomGif.Model
app = Box.start <| fst <| randomGif "funny cats" Box.rootAction 

main : Signal Html
main = app.html


port tasks : Box.Tasks
port tasks = app.tasks


