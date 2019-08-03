port module Main exposing (init)

import Browser
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Html
import Html.Attributes
import Html.Events
import Markdown
import Pages exposing (Page(..))
import Route exposing (Route)
import SvgParser
import Url exposing (Url)
import Url.Builder



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    { navKey : Nav.Key
    , page : Page
    }


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
                    Route.replaceUrl model.navKey Route.Introduction

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
                Just Route.Introduction ->
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


tableOfContents : Model -> Element Msg
tableOfContents m =
    let
        selected isSelected =
            case isSelected of
                True ->
                    Font.color (rgb255 40 80 200)

                False ->
                    Font.color (rgb255 0 40 80)

        mapLink page =
            paragraph []
                [ link
                    [ selected (m.page == page)
                    , mouseOver [ Font.color (rgba255 0 91 150 1) ]
                    ]
                    { url = "/" ++ Pages.pageToRoute page, label = text (Pages.pageToTitle page) }
                ]
    in
    column [ spacing 15 ]
        (List.map
            mapLink
            [ Introduction, ErsterTeil ]
        )


commentary : Model -> Html.Html Msg
commentary m =
    let
        markdownTexts =
            String.split "@@" (Pages.pageToContent m.page)
    in
    Html.div [] (List.map SvgParser.filterText markdownTexts)


view : Model -> Html.Html Msg
view m =
    layout []
        (row [ height fill ]
            [ el [ width (px 300), height fill, padding 10 ] (tableOfContents m)
            , el [ Background.color (rgb 0.88 0.88 0.88), width fill, height fill, padding 20 ]
                (Element.paragraph [ spacing 10 ] [ Element.html <| commentary m ])
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
