module CounterList exposing (..)

import Counter exposing (counter, onCounterUpdate, value)
import Html exposing (..)
import Html.Events exposing (..)


-- MODEL


type alias Model =
    { counters : List ( ID, Int )
    , nextID : ID
    }


type alias ID =
    Int


init : Model
init =
    { counters = []
    , nextID = 0
    }



-- UPDATE


type Msg
    = Insert
    | Remove
    | UpdateCounter ID Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        Insert ->
            let
                newCounter =
                    ( model.nextID, 0 )

                newCounters =
                    model.counters ++ [ newCounter ]
            in
                { model
                    | counters = newCounters
                    , nextID = model.nextID + 1
                }

        Remove ->
            { model | counters = List.drop 1 model.counters }

        UpdateCounter idx newValue ->
            let
                updateCounter ( i, oldValue ) =
                    if idx == i then
                        ( i, newValue )
                    else
                        ( i, oldValue )
            in
                { model | counters = List.map updateCounter model.counters }



-- VIEW


view : Model -> Html Msg
view model =
    let
        counters =
            List.map viewCounter model.counters

        remove =
            button [ onClick Remove ] [ text "Remove" ]

        insert =
            button [ onClick Insert ] [ text "Add" ]
    in
        div [] ([ remove, insert ] ++ counters)


viewCounter : ( ID, Int ) -> Html Msg
viewCounter ( idx, val ) =
    div [] [ counter [ value val, onCounterUpdate (UpdateCounter idx) ] [] ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init, update = update, view = view }
