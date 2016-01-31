module RandomGifList where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json

import RandomGif 
import Box exposing (Effects, batchFx, noFx, ID, nextId)


-- MODEL

type alias Model =
    { topic : String
    , gifList : List (ID, RandomGif.RandomGif Action)
    }


init : (Model, Effects Action)
init =
    ( Model "" [], noFx )


-- UPDATE

type Action
    = Topic String
    | Create
    | SubMsg ID RandomGif.Action


update : Action -> Model -> (Model, Effects Action)
update action model =
    case action of
        Topic topic ->
            ( { model | topic = topic }
            , noFx
            )

        Create ->
            let
                (child, fx) = RandomGif.randomGif model.topic (SubMsg 0) 
                id = nextId model.gifList
            in
                ( Model "" (model.gifList ++ [(id, child)]), fx )

        SubMsg msgId msg ->
            let
                (gifList', fx) = Box.updateChildren SubMsg msgId msg model.gifList

            in
                ({ model | gifList = gifList'}, fx)

-- VIEW
(=>) : a -> b -> ( a, b )
(=>) = (,)


view : Signal.Address Action -> Model -> Html
view address model =
    div []
        [ input
            [ placeholder "What kind of gifs do you want?"
            , value model.topic
            , onEnter address Create
            , on "input" targetValue (Signal.message address << Topic)
            , inputStyle
            ]
            []
        , div [ style [ "display" => "flex", "flex-wrap" => "wrap" ] ]
            (Box.viewChildren address SubMsg model.gifList)
        ]


inputStyle : Attribute
inputStyle =
    style
        [ ("width", "100%")
        , ("height", "40px")
        , ("padding", "10px 0")
        , ("font-size", "2em")
        , ("text-align", "center")
        ]


onEnter : Signal.Address a -> a -> Attribute
onEnter address value =
    on "keydown"
        (Json.customDecoder keyCode is13)
        (\_ -> Signal.message address value)


is13 : Int -> Result String ()
is13 code =
    if code == 13 then
        Ok ()

    else
        Err "not the right key code"

type alias RandomGifList a = Box.Config Model Action a

randomGifList : (Action -> parentAction) -> RandomGifList parentAction
randomGifList toParentAction = 
  Box.box init (Box.withParentFx toParentAction update) view []


-- MAIN WIRING 

app : Box.App Model
app = Box.start <| randomGifList Box.rootAction

main : Signal Html
main = app.html 

port tasks : Box.Tasks
port tasks = app.tasks
