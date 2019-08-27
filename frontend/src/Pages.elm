module Pages exposing (Page(..), pageToContent, pageToRoute, pageToTitle)

import Commentary.ErsterTeil as ErsterTeil
import Commentary.Introduction as Introduction
import Commentary.TheoreticalPhilosophy as TheoreticalPhilosophy


type Page
    = Introduction
    | ErsterTeil
    | TheoretischesTeil


pageToRoute : Page -> String
pageToRoute page =
    case page of
        Introduction ->
            ""

        ErsterTeil ->
            "erster_teil"

        TheoretischesTeil ->
            "theoretisches_teil"


pageToTitle : Page -> String
pageToTitle page =
    case page of
        Introduction ->
            "Introduction"

        ErsterTeil ->
            "Grundsätze der gesamten Wissenschaftslehre"

        TheoretischesTeil ->
            "Theoretic Philosophy"


pageToContent : Page -> String
pageToContent page =
    case page of
        Introduction ->
            Introduction.content

        ErsterTeil ->
            ErsterTeil.content

        TheoretischesTeil ->
            TheoreticalPhilosophy.content
