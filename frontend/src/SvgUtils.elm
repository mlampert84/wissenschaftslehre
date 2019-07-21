module SvgUtils exposing (Dimension, dimensionsToString, dimensionsToViewBox, normalizeFont, toSvgCoord)

import Point2d exposing (Point2d)
import Svg exposing (Attribute, Svg)
import Svg.Attributes as Attributes


type alias Dimension =
    { width : Float
    , height : Float
    }


dimensionsToString : Dimension -> String
dimensionsToString d =
    "0 0 "
        ++ String.fromFloat d.width
        ++ " "
        ++ String.fromFloat d.height


dimensionsToViewBox : Dimension -> String
dimensionsToViewBox d =
    String.fromFloat (-d.width / 2)
        ++ " "
        ++ String.fromFloat (-d.height / 2)
        ++ " "
        ++ String.fromFloat d.width
        ++ " "
        ++ String.fromFloat d.height


toSvgCoord : Point2d -> List (Attribute msg)
toSvgCoord point =
    let
        ( x, y ) =
            Point2d.coordinates point
    in
    [ Attributes.x (String.fromFloat x)
    , Attributes.y (String.fromFloat -y)
    ]


normalizeFont : Dimension -> Dimension -> Int -> Attribute msg
normalizeFont actual viewBox size =
    let
        ratio =
            Basics.min (actual.width / viewBox.width) (actual.height / viewBox.height)
    in
    Attributes.fontSize <| String.fromInt <| round <| toFloat size / ratio
