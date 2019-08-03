module Route exposing (Route(..), fromUrl, maybeRouteToString, replaceUrl, routeToString)

import Browser.Navigation as Nav
import Url exposing (Url)
import Url.Builder as Builder
import Url.Parser as Parser exposing ((</>), (<?>), map, s)
import Url.Parser.Query as Query


type Route
    = Overview
    | Commentary (Maybe String)
    | Glossary
    | About
    | ErsterTeil


parser : Parser.Parser (Route -> a) a
parser =
    Parser.oneOf
        [ map Overview Parser.top
        , map Commentary (s "commentary" <?> Query.string "id")
        , map Glossary (s "glossary")
        , map About (s "about")
        ]


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key <| Debug.log "changing route to" (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    Parser.parse parser url


maybeRouteToString : Maybe Route -> String
maybeRouteToString route =
    case route of
        Nothing ->
            "/"

        Just r ->
            routeToString r


routeToString : Route -> String
routeToString page =
    case page of
        Overview ->
            "/"

        Commentary Nothing ->
            "commentary"

        Commentary (Just section) ->
            Builder.relative [ "commentary" ] [ Builder.string "id" section ]

        Glossary ->
            "glossary"

        About ->
            "about"

        ErsterTeil ->
            "erster_teil"
