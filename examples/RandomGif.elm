module RandomGif exposing (randomGif, topic, onMore)

import Html exposing (..)
import Html.Attributes exposing (attribute, style)
import Html.Events exposing (..)
import Box exposing (..)
import Json.Encode as JE exposing (Value)
import Json.Decode as Json exposing (Decoder)
import Http


-- WIRING


boxName : String
boxName =
    "elm-random-gif"


{-| Defines the box
-}
box : Box
box =
    Box.define
        { name = boxName
        , attributeDecoder = attributeDecoder
        , init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        , css = css
        }


css : String
css =
    """
elm-random-gif div {
    display: inline-block;
    margin: 10px;
}
"""



-- INTERFACE FOR THE BOX


{-| the Html node that ends up being used
-}
randomGif : List (Attribute msg) -> List (Html msg) -> Html msg
randomGif =
    node boxName


{-| attribute for setting the topic of the component
-}
topic : String -> Attribute msg
topic =
    attribute "topic"


{-| Event for when the user clicks More
-}
onMore : msg -> Attribute msg
onMore msg =
    on "more" (Json.succeed msg)


{-| a decoder that helps feed the arguments back into the component as messages
-}
attributeDecoder : String -> String -> Decoder Msg
attributeDecoder name value =
    case name of
        "topic" ->
            Json.succeed (ChangeTopic value)

        _ ->
            Json.fail "unknown attribute"



-- IMPLEMENTATION


type alias Model =
    { topic : String
    , gifUrl : String
    }


init : List Msg -> ( Model, Cmd Msg )
init attrs =
    let
        updateAttributes msg ( model, cmds ) =
            let
                ( newModel, cmd, _ ) =
                    update msg model
            in
                ( newModel, cmd )
    in
        List.foldr updateAttributes ( Model "cats" "assets/waiting.gif", getRandomGif "cats" ) attrs


type Msg
    = MorePlease
    | FetchSucceed String
    | FetchFail
    | ChangeTopic String


update : Msg -> Model -> ( Model, Cmd Msg, Event )
update msg model =
    case Debug.log "RandomGif:" msg of
        MorePlease ->
            ( model, getRandomGif model.topic, event "more" JE.null )

        FetchSucceed newUrl ->
            ( Model model.topic newUrl, Cmd.none, noEvent )

        FetchFail ->
            ( model, Cmd.none, noEvent )

        ChangeTopic topic ->
            if topic /= model.topic then
                ( { model | topic = topic }, getRandomGif topic, noEvent )
            else
                ( model, Cmd.none, noEvent )



-- VIEW


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


view : Model -> Html Msg
view model =
    div [ style [ "width" => "200px" ] ]
        [ h2 [ headerStyle ] [ text model.topic ]
        , div [ imgStyle model.gifUrl ] []
        , button [ onClick MorePlease ] [ text "More Please!" ]
        ]


headerStyle : Attribute Msg
headerStyle =
    style
        [ "width" => "200px"
        , "text-align" => "center"
        ]


imgStyle : String -> Attribute Msg
imgStyle url =
    style
        [ "display" => "inline-block"
        , "width" => "200px"
        , "height" => "200px"
        , "background-position" => "center center"
        , "background-size" => "cover"
        , "background-image" => ("url('" ++ url ++ "')")
        ]



-- EFFECTS


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic

        handler result =
            case result of
                Ok payload ->
                    FetchSucceed payload

                Err err ->
                    FetchFail
    in
        Http.get url decodeGifUrl
            |> Http.send handler


decodeGifUrl : Json.Decoder String
decodeGifUrl =
    Json.at [ "data", "image_url" ] Json.string


main : Html msg
main =
    randomGif [ topic "sloths" ] []
