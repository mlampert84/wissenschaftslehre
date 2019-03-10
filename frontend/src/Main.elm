port module Main exposing (Model, Msg(..), Page(..), init, main, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    { page : Page
    }


type Page
    = Overview
    | Text
    | About


init : Int -> ( Model, Cmd Msg )
init flags =
    ( { page = Overview }, Cmd.none )



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = ToOverview
    | ToText
    | ToAbout


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ToOverview ->
            ( { page = Overview }, Cmd.none )

        ToText ->
            ( { page = Text }, Cmd.none )

        ToAbout ->
            ( { page = About }, Cmd.none )



-- ---------------------------
-- VIEW
-- ---------------------------


view : Model -> Html Msg
view model =
    div [] [ text "Hello there" ]



-- ---------------------------
-- MAIN
-- ---------------------------


main : Program Int Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view =
            \m ->
                { title = "Wissenschaftslehre"
                , body = [ view m ]
                }
        , subscriptions = \_ -> Sub.none
        }
