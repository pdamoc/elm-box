module RandomGifList exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import RandomGif exposing (randomGif, topic)


-- MODEL


type alias Model =
    { topic : String
    , topicList : List ( Int, String )
    , uid : Int
    }


init : Model
init =
    Model "" [] 0



-- UPDATE


type Msg
    = Topic String
    | Create


update : Msg -> Model -> Model
update message model =
    case message of
        Topic topic ->
            { model | topic = topic }

        Create ->
            Model "" (model.topicList ++ [ ( model.uid, model.topic ) ]) (model.uid + 1)



-- VIEW


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


view : Model -> Html Msg
view model =
    div []
        [ input
            [ placeholder "What kind of gifs do you want?"
            , value model.topic
            , onEnter model.topic
            , on "input" (Json.map Topic targetValue)
            , inputStyle
            ]
            []
        , div [ style [ "display" => "flex", "flex-wrap" => "wrap" ] ]
            (List.map elementView model.topicList)
        ]


elementView : ( Int, String ) -> Html Msg
elementView ( id, t ) =
    randomGif [ topic t ] []


inputStyle : Attribute Msg
inputStyle =
    style
        [ ( "width", "100%" )
        , ( "height", "40px" )
        , ( "padding", "10px 0" )
        , ( "font-size", "2em" )
        , ( "text-align", "center" )
        ]


onEnter : String -> Attribute Msg
onEnter topic =
    let
        createOnEnter code =
            if code == 13 then
                Create
            else
                (Topic topic)
    in
        on "keydown" (Json.map createOnEnter keyCode)


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init, update = update, view = view }
