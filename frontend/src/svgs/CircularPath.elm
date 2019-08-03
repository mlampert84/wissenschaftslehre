module CircularPath exposing (diagram, initialInteraction)

import Svg exposing (..)
import Svg.Attributes as Attributes exposing (..)
import SvgUtils exposing (Dimension, dimensionsToString, normalizeFont)


type alias Point =
    { x : Float
    , y : Float
    }


viewBoxSize : Dimension
viewBoxSize =
    Dimension 400 200


actualSize : Dimension
actualSize =
    Dimension 600 300


toSvgCoord : Point -> List (Attribute msg)
toSvgCoord point =
    [ x (String.fromFloat (viewBoxSize.width / 2 + point.x))
    , y (String.fromFloat (viewBoxSize.height / 2 - point.y))
    ]


initialInteraction : Svg msg
initialInteraction =
    svg
        [ width (String.fromFloat actualSize.width)
        , height (String.fromFloat actualSize.height)
        , viewBox (dimensionsToString viewBoxSize)
        , Attributes.style "background-color: pink"
        ]
        []


diagram : Svg msg
diagram =
    svg
        [ width "600"
        , height "600"
        , viewBox (dimensionsToString viewBoxSize)
        ]
        [ Svg.path
            [ Attributes.stroke "red"
            , Attributes.d "M 60, 0 A 48 48 0 0 1 80, 91.7"
            ]
            []
        , Svg.path
            [ Attributes.stroke "red"
            , Attributes.d "M 60, 96  A 48 48 1 0 1 25, 15"
            ]
            []
        , Svg.circle
            [ Attributes.cx "60"
            , Attributes.cy "48"
            , Attributes.r "48"
            , Attributes.stroke "green"
            , Attributes.fill "none"
            , Attributes.strokeDasharray "3 1"
            ]
            []
        ]
