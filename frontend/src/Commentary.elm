module Commentary exposing (SectionName(..), view)

import CircularPath
import Commentary.ErsterTeil
import FirstSvg
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Markdown
import TableOfContents exposing (sections)
import Text.TextTypes exposing (Section)
import Url.Builder as Builder


type SectionName
    = ErsterTeil


sectionText : Section -> Html msg
sectionText section =
    li []
        [ a
            [ style "text-indent" (String.fromInt (section.level * 20) ++ "px")
            , href (Builder.relative [ "commentary" ] [ Builder.string "id" section.id ])
            ]
            [ text section.title ]
        ]


tableOfContents : List Section -> Html msg
tableOfContents list =
    ul [] (List.map sectionText list)


textToView : String -> Html msg
textToView str =
    Markdown.toHtml [ class "commentary" ] str


commentaryView : SectionName -> Html msg
commentaryView section =
    case section of
        ErsterTeil ->
            textToView Commentary.ErsterTeil.mainText


content : Html msg
content =
    Markdown.toHtml [ class "content" ] """

# Apple Pie Recipe

  1. Invent the universe.
  2. Bake an apple pie.

"""


view : SectionName -> Html msg
view section =
    div [ class "commentary-container" ]
        [ div [ class "table-of-contents" ]
            [ h2 [] [ text "Table of contents" ]
            , tableOfContents sections
            ]
        , div
            [ class "text-and-commentary" ]
            [ commentaryView section, FirstSvg.firstSvg ]
        ]
