port module Main exposing (Model, Msg(..), Page(..), init, main, update, view)

import About
import Browser
import Browser.Navigation as Nav
import Glossary
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode
import Overview
import Text
import Url exposing (Url)



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    { page : Page
    }


type Page
    = Overview
    | Text
    | Glossary
    | About


init : Int -> Url -> Nav.Key -> ( Model, Cmd Msg )
init key url flags =
    ( { page = Overview }, Cmd.none )



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = ToOverview
    | ToText
    | ToAbout
    | ToGlossary
    | ClickedLink Browser.UrlRequest
    | ChangedUrl Url


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ToOverview ->
            ( { page = Overview }, Cmd.none )

        ToText ->
            ( { page = Text }, Cmd.none )

        ToAbout ->
            ( { page = About }, Cmd.none )

        ToGlossary ->
            ( { page = Glossary }, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- ---------------------------
-- VIEW
-- ---------------------------


selectedNavItem : Page -> Page -> Attribute Msg
selectedNavItem page model =
    classList [ ( "selected", page == model ) ]


mainMarkdown : Model -> Html Msg
mainMarkdown m =
    case m.page of
        Overview ->
            Overview.view

        Text ->
            Text.view

        Glossary ->
            Glossary.view

        About ->
            About.view


view : Model -> Html Msg
view model =
    div []
        [ h1 [ class "pageTitle" ] [ text "Wissenschaftslehre" ]
        , h3 [ class "pageSubtitle" ] [ text "A Commentary" ]
        , li [ class "nav" ]
            [ ul [ selectedNavItem model.page Overview, onClick ToOverview ] [ text "Overview" ]
            , ul [ selectedNavItem model.page Text, onClick ToText ] [ text "Text" ]
            , ul [ selectedNavItem model.page Glossary, onClick ToGlossary ] [ text "Glossary" ]
            , ul [ selectedNavItem model.page About, onClick ToAbout ] [ text "About" ]
            ]
        , mainMarkdown model
        ]



-- ---------------------------
-- MAIN
-- ---------------------------


main : Program Int Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view =
            \m ->
                { title = "Wissenschaftslehre"
                , body = [ view m ]
                }
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }
