module SvgParser exposing (filterText)

import Html
import Markdown
import Svg exposing (Svg)
import Svgs.ESynthesis exposing (diagram)
import Svgs.FirstSvg exposing (firstSvg)


filterText : String -> Html.Html msg
filterText text =
    case text of
        "SVG1" ->
            firstSvg

        "SVG3" ->
            diagram

        _ ->
            Markdown.toHtml [] text


returnSvg : String -> Svg msg
returnSvg string =
    firstSvg
