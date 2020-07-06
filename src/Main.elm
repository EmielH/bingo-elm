module Main exposing (..)

import Browser
import Html exposing (Html, div, text, span, button)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Random
import Random.List



-- MAIN


main =
    Browser.element { init = init, update = update, subscriptions = subscriptions, view = view }



-- MODEL


type alias Model =
    List Entry


type alias Entry =
    { description : String
    , completed : Bool
    }


allEntries: Model
allEntries =
    let
        createEntry : String -> Entry
        createEntry text =
            { description = text
            , completed = False
            }
    in
        List.map createEntry (List.map (\i -> "Bingo " ++ String.fromInt i) (List.range 1 24))

init : () -> (Model, Cmd Msg)
init _ =
    ( []
    , Random.generate RandomList (Random.List.shuffle allEntries)
    )


-- UPDATE


type Msg
    = Toggle Entry
    | RandomList (List Entry)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Toggle entry ->
            let
                updateEntry : Entry -> Entry
                updateEntry t =
                    if t.description == entry.description then
                        { t | completed = not entry.completed }
                    else
                        t
            in
                ( List.map updateEntry model
                , Cmd.none
                )
        RandomList list ->
            ( List.take 16 list
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        (List.map viewEntry model)

viewEntry : Entry -> Html Msg
viewEntry entry =
    if entry.completed then
        span [ style "border" "1px solid black", style "background-color" "green", style "width" "200px", style "height" "200px", onClick (Toggle entry) ] [ text entry.description ]
    else
        span [ style "border" "1px solid black", style "width" "200px", style "height" "200px", onClick (Toggle entry) ] [ text entry.description ]
