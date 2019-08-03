port module Main exposing (init)

import Browser
import Browser.Navigation as Nav
import Commentary.ErsterTeil as ErsterTeil
import Commentary.Introduction as Introduction
import Element exposing (..)
import Element.Background as Background
import Html
import Html.Attributes
import Html.Events
import Markdown
import Route exposing (Route)
import Text.TextTypes exposing (Section)
import Url exposing (Url)
import Url.Builder



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    { navKey : Nav.Key
    , page : Page
    }


type Page
    = Introduction
    | ErsterTeil


init : Int -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flag url key =
    changeRouteTo (Debug.log "the parsed route" (Route.fromUrl url))
        False
        { navKey = key, page = Introduction }


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
                Just Route.Overview ->
                    Introduction

                Just Route.ErsterTeil ->
                    ErsterTeil

                _ ->
                    Introduction
    in
    ( { model | page = page }, Cmd.batch [ correctUrl, newUrl ] )


type Msg
    = ToIntroduction
    | ToErsterTeil
    | ClickedLink Browser.UrlRequest
    | ChangedUrl Url


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ToIntroduction ->
            ( { model | page = Introduction }, Cmd.none )

        ToErsterTeil ->
            ( { model | page = ErsterTeil }, Cmd.none )

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


tableOfContents : Element Msg
tableOfContents =
    let
        mapLink section =
            link [] { url = "/" ++ section.id, label = text section.title }
    in
    column []
        (List.map
            mapLink
            [ Introduction.section, ErsterTeil.section ]
        )


commentary : Model -> Html.Html Msg
commentary m =
    let
        text =
            case m.page of
                Introduction ->
                    Introduction.mainText

                ErsterTeil ->
                    ErsterTeil.mainText
    in
    Markdown.toHtml [ Html.Attributes.class "markdown" ] text


view : Model -> Html.Html Msg
view m =
    layout [ Background.color (rgb 0.88 0.88 0.88) ]
        (row [ width fill, height fill ]
            [ el [ Background.color (rgb 1 0.5 0.5), width (px 300), height fill ] tableOfContents
            , el [ Background.color (rgb 0.25 1 0), width fill, height fill ] (Element.html <| commentary m)
            ]
        )


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
