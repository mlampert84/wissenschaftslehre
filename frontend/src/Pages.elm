module Pages exposing (Page(..), pageToContent, pageToRoute, pageToTitle)

import Commentary.ErsterTeil as ErsterTeil
import Commentary.Introduction as Introduction


type Page
    = Introduction
    | ErsterTeil


pageToRoute : Page -> String
pageToRoute page =
    case page of
        Introduction ->
            ""

        ErsterTeil ->
            "erster_teil"


pageToTitle : Page -> String
pageToTitle page =
    case page of
        Introduction ->
            "Introduction"

        ErsterTeil ->
            "Grundsätze der gesamten Wissenschaftslehre"


pageToContent : Page -> String
pageToContent page =
    case page of
        Introduction ->
            Introduction.content

        ErsterTeil ->
            ErsterTeil.content
