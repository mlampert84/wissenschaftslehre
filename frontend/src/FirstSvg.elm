module FirstSvg exposing (firstSvg)

import Frame2d exposing (Frame2d)
import Geometry.Svg as Svg
import LineSegment2d exposing (LineSegment2d)
import Point2d exposing (Point2d)
import Svg exposing (Svg)
import Svg.Attributes as Attributes
import SvgUtils exposing (Dimension, dimensionsToString, dimensionsToViewBox, normalizeFont, toSvgCoord)
import Triangle2d
import Vector2d


viewBoxSize : Dimension
viewBoxSize =
    Dimension 200 200


actualSize : Dimension
actualSize =
    Dimension 500 300


frame : Frame2d
frame =
    Frame2d.reverseY <| Frame2d.atCoordinates ( 0, actualSize.height )


lineSegment : LineSegment2d -> Svg msg
lineSegment line =
    Svg.lineSegment2d
        [ Attributes.stroke "black"
        , Attributes.strokeWidth "2"
        ]
        line


triangle : Point2d -> Float -> Svg msg
triangle p rotation =
    let
        ( px, py ) =
            Point2d.coordinates p

        length =
            10.0

        height =
            1.732 * length / 2
    in
    Svg.rotateAround p (degrees rotation) <|
        Svg.triangle2d
            [ Attributes.stroke "red"
            , Attributes.strokeWidth "0"

            -- , Attributes.strokeLinejoin "round"
            , Attributes.fill "black"
            ]
            (Triangle2d.fromVertices
                ( Point2d.fromCoordinates ( px, py + height / 2 )
                , Point2d.fromCoordinates ( px + length / 2, py - height / 2 )
                , Point2d.fromCoordinates ( px - length / 2, py - height / 2 )
                )
            )


makeText : String -> Point2d -> Int -> String -> Svg msg
makeText text point fontSize textAnchor =
    Svg.text_
        (toSvgCoord point
            ++ [ Attributes.transform "scale(1,-1)"
               , Attributes.alignmentBaseline "middle"
               , normalizeFont actualSize viewBoxSize fontSize
               , Attributes.textAnchor textAnchor
               ]
        )
        [ Svg.text text ]



-- text_ (toSvgCoord (Point -180 0) ++  [ text "The Self" ]
-- notSelf : Svg msg
-- notSelf =
--     Svg.text_ (toSvgCoord (Point 180 0) ++ [ alignmentBaseline "middle", textAnchor "end", normalizeFont actualSize viewBoxSize 24 ]) [ text "The Non-Self" ]


scene : Svg msg
scene =
    Svg.svg
        [ Attributes.viewBox (dimensionsToViewBox viewBoxSize)
        ]
        [ lineSegment
            (LineSegment2d.fromEndpoints
                ( Point2d.fromCoordinates ( -10, 75 )
                , Point2d.fromCoordinates ( -10, -75 )
                )
            )
        , lineSegment
            (LineSegment2d.fromEndpoints
                ( Point2d.fromCoordinates ( 10, 75 )
                , Point2d.fromCoordinates ( 10, -75 )
                )
            )
        , triangle (Point2d.fromCoordinates ( 10, 75 )) 0
        , triangle (Point2d.fromCoordinates ( -10, -75 )) 180
        , makeText "The Self" (Point2d.fromCoordinates ( 0, 90 )) 24 "middle"
        , makeText "The Non-Self" (Point2d.fromCoordinates ( 0, -90 )) 24 "middle"
        , makeText "The Practical" (Point2d.fromCoordinates ( -150, 0 )) 24 "beginning"
        , makeText "The Theoretical" (Point2d.fromCoordinates ( 150, 0 )) 24 "end"
        , makeText "determines the" (Point2d.fromCoordinates ( -15, 60 )) 20 "end"
        , makeText "determines the" (Point2d.fromCoordinates ( 15, -60 )) 20 "beginning"

        -- , makeText "determines the" (Point2d.fromCoordinates ( 95, 0 )) 24 "end"
        ]


firstSvg : Svg msg
firstSvg =
    Svg.svg
        [ Attributes.width (String.fromFloat actualSize.width)
        , Attributes.height (String.fromFloat actualSize.height)
        , Attributes.style "background-color: white"
        ]
        [ Svg.relativeTo frame scene ]



--   ([ Svg.rect [ Attributes.x "-100", Attributes.y "-100", Attributes.width "100", Attributes.height "100", Attributes.rx "15", Attributes.ry "15" ] [] ]
