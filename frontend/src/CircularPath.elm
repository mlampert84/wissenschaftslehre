module CircularPath exposing (Dimension, diagram, dimensionsToString, size)

import Svg exposing (..)
import Svg.Attributes as Attributes exposing (..)


type alias Dimension =
    { width : Int
    , height : Int
    }


size : Dimension
size =
    Dimension 120 96


dimensionsToString : String
dimensionsToString =
    "0 0 "
        ++ String.fromInt size.width
        ++ " "
        ++ String.fromInt size.height


diagram : Svg msg
diagram =
    svg
        [ width "600"
        , height "600"
        , viewBox dimensionsToString
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
