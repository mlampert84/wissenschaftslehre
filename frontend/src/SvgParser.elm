module SvgParser exposing (filterText)

import Html
import Markdown
import Svg exposing (Svg)
import Svgs.FirstSvg exposing (firstSvg)


filterText : String -> Html.Html msg
filterText text =
    case text of
        "SVG1" ->
            firstSvg

        _ ->
            Markdown.toHtml [] text


returnSvg : String -> Svg msg
returnSvg string =
    firstSvg
