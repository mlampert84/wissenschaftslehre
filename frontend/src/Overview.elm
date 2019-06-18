module Overview exposing (view)

import CircularPath
import ESynthesis
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


introduction : String
introduction =
    "This site serves as a guide to reading Fichtes 1794 %iGrundlage der gesamten Wissenschaftslehre%i.  While most information can be found in the %iText%i section of this site, we introduce here two diagrams that serve as general roadmaps to understanding the text."


italicizeText : String -> List (Html msg)
italicizeText str =
    let
        list =
            List.indexedMap Tuple.pair << String.split "%i" <| str

        mapper ( x, y ) =
            case modBy 2 x of
                0 ->
                    text y

                otherwise ->
                    i [] [ text y ]
    in
    List.map mapper list


view : Html msg
view =
    div []
        [ p [] (italicizeText introduction)
        , h2 [] [ text "Overall plan of the Wissenschaftslehre" ]
        , h2 [] [ text "Put SVG here." ]
        , CircularPath.diagram
        , ESynthesis.diagram
        ]
