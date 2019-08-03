port module OldMain exposing (Model, Msg(..), Page(..), init, main, update, view)

import About
import Browser
import Browser.Navigation as Nav
import Commentary
import Glossary
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode
import Overview
import Route exposing (Route)
import Url exposing (Url)
import Url.Builder



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    { navKey : Nav.Key
    , page : Page
    , commentarySection : Commentary.SectionName
    }


type Page
    = Overview
    | Commentary
    | Glossary
    | About


init : Int -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flag url key =
    changeRouteTo (Debug.log "the parsed route" (Route.fromUrl url))
        False
        { navKey = key, page = Commentary, commentarySection = Commentary.ErsterTeil }


changeRouteTo : Maybe Route -> Bool -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute pushUrl model =
    let
        correctUrl =
            case maybeRoute of
                Nothing ->
                    Route.replaceUrl model.navKey Route.Overview

                otherwise ->
                    Cmd.none

        newUrl =
            case pushUrl of
                True ->
                    Nav.pushUrl model.navKey (Route.maybeRouteToString maybeRoute)

                False ->
                    Cmd.none

        page =
            case maybeRoute of
                Nothing ->
                    Commentary

                Just Route.Overview ->
                    Commentary

                Just (Route.Commentary maybeId) ->
                    Commentary

                Just Route.Glossary ->
                    Glossary

                Just Route.About ->
                    About
    in
    ( { model | page = page }, Cmd.batch [ correctUrl, newUrl ] )



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = ToOverview
    | ToCommentary
    | ToAbout
    | ToGlossary
    | ClickedLink Browser.UrlRequest
    | ChangedUrl Url


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ToOverview ->
            ( { model | page = Overview }, Cmd.none )

        ToCommentary ->
            ( { model | page = Commentary }, Cmd.none )

        ToAbout ->
            ( { model | page = About }, Cmd.none )

        ToGlossary ->
            ( { model | page = Glossary }, Cmd.none )

        ClickedLink urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    changeRouteTo (Route.fromUrl url) True model

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        ChangedUrl url ->
            changeRouteTo (Route.fromUrl url) False model



-- changeRouteTo (Route.fromUrl url) False model
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

        Commentary ->
            Commentary.view m.commentarySection

        Glossary ->
            Glossary.view

        About ->
            About.view


view : Model -> Html Msg
view model =
    div []
        [ h1 [ class "pageTitle" ] [ text "Wissenschaftslehre" ]
        , h3 [ class "pageSubtitle" ] [ text "A Commentary" ]
        , ul [ class "nav" ]
            [ li [ selectedNavItem model.page Overview ]
                [ a [ href "/" ] [ text "Overview" ]
                ]
            , li [ selectedNavItem model.page Commentary ]
                [ a [ href "/commentary" ] [ text "Text" ]
                ]
            , li [ selectedNavItem model.page Glossary ]
                [ a [ href "/glossary" ] [ text "Glossary" ]
                ]
            , li [ selectedNavItem model.page About ]
                [ a [ href "/about" ] [ text "About" ] ]
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
