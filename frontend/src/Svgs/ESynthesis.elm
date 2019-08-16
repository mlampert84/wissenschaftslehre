module ESynthesis exposing (diagram)

import Svg exposing (..)
import Svg.Attributes as Attributes exposing (..)


type alias Dimension =
    { width : Int
    , height : Int
    }


type alias Delta =
    { deltaX : Int
    , deltaY : Int
    }


type alias Point =
    { x : Int
    , y : Int
    }


type alias Line =
    { start : Point
    , end : Point
    }


type alias Leaf =
    Point


type Tree
    = Node Point (Maybe String) Tree Tree
    | Leaf Point (Maybe String)


leftPoint : Point -> Delta -> Point
leftPoint point delta =
    Point (point.x - delta.deltaX) (point.y + delta.deltaY)


rightPoint : Point -> Delta -> Point
rightPoint point delta =
    Point (point.x + delta.deltaX) (point.y + delta.deltaY)



--Makes a tree of depth 1


theLabels : List ( String, String )
theLabels =
    [ ( "Causality", "Substance" )
    , ( "Exchange", "Independent Activity" )
    , ( "Matter", "Form" )
    ]


makeTree : Point -> Maybe String -> List ( String, String ) -> List Delta -> Tree
makeTree point label futureLabels deltas =
    let
        ( text1, text2, texts ) =
            case futureLabels of
                [] ->
                    ( Nothing, Nothing, [] )

                ( txt1, txt2 ) :: txts ->
                    ( Just txt1, Just txt2, txts )
    in
    case deltas of
        [] ->
            Leaf point label

        x :: xs ->
            Node point
                label
                (makeTree (leftPoint point x) text1 texts xs)
                (makeTree (rightPoint point x) text2 texts xs)


makeLines : Tree -> List Line
makeLines tree =
    let
        treeRecurse point subTree =
            case subTree of
                Leaf subPoint _ ->
                    [ Line point subPoint ]

                Node subPoint text subT1 subT2 ->
                    [ Line point subPoint ]
                        ++ treeRecurse subPoint subT1
                        ++ treeRecurse subPoint subT2
    in
    case tree of
        Leaf _ _ ->
            []

        Node p text t1 t2 ->
            treeRecurse p t1 ++ treeRecurse p t2


type alias Label =
    { point : Point
    , text : String
    }


makeLabels : Tree -> List Label
makeLabels tree =
    case tree of
        Leaf point (Just label) ->
            [ Label point label ]

        Leaf _ Nothing ->
            []

        Node point (Just label) t1 t2 ->
            [ Label point label ]
                ++ makeLabels t1
                ++ makeLabels t2

        Node _ Nothing t1 t2 ->
            makeLabels t1 ++ makeLabels t2


size : Dimension
size =
    Dimension 120 96


dimensionsToString : String
dimensionsToString =
    "0 0 "
        ++ String.fromInt size.width
        ++ " "
        ++ String.fromInt size.height


svgLabel : Int -> Label -> Svg msg
svgLabel offset label =
    let
        dy =
            case label.text of
                "Matter" ->
                    2

                "Form" ->
                    2

                otherwise ->
                    offset

        dx =
            case label.text of
                "Causality" ->
                    -2

                "Substance" ->
                    2

                otherwise ->
                    0
    in
    Svg.text_
        [ Attributes.x (String.fromInt label.point.x)
        , Attributes.y (String.fromInt label.point.y)
        , Attributes.dy (String.fromInt dy)
        , Attributes.dx (String.fromInt dx)
        , Attributes.textAnchor "middle"
        , Attributes.fontSize "3"
        , Attributes.fill "black"
        ]
        [ text label.text ]


theDeltas : List Delta
theDeltas =
    [ Delta (size.width // 4) (size.height // 9)
    , Delta (size.width // 8) (size.height // 6)
    , Delta (size.width // 14) (size.height // 6)
    ]


theTree : Tree
theTree =
    makeTree (Point (size.width // 2) 0) Nothing theLabels theDeltas



-- The midline is determined by theDeltas, even though I didn't dynamically code it.


flipPoint : Point -> Point
flipPoint p =
    let
        midLine =
            size.height // 9 + size.height // 6 + size.height // 6 + 1
    in
    Point p.x ((midLine - p.y) + midLine)


flipLinesVertical : List Line -> List Line
flipLinesVertical lines =
    let
        flipLine l =
            Line (flipPoint l.start) (flipPoint l.end)
    in
    List.map flipLine lines


flipLabel : Label -> Label
flipLabel label =
    { label | point = flipPoint label.point }


flipLabelsVertical : List Label -> List Label
flipLabelsVertical labels =
    let
        filterFunc label =
            label.text /= "Matter" && label.text /= "Form"
    in
    List.map flipLabel << List.filter filterFunc <| labels


blackLine : Float -> Line -> Svg msg
blackLine width line =
    Svg.line
        [ Attributes.x1 (String.fromInt line.start.x)
        , Attributes.y1 (String.fromInt line.start.y)
        , Attributes.x2 (String.fromInt line.end.x)
        , Attributes.y2 (String.fromInt line.end.y)
        , Attributes.strokeWidth (String.fromFloat width)
        , stroke "black"
        ]
        []


diagram : Svg msg
diagram =
    svg
        [ width "600"
        , height "600"
        , viewBox dimensionsToString
        ]
        ((List.map (blackLine 0.25) << makeLines <| theTree)
            ++ (List.map (blackLine 0.25) << flipLinesVertical << makeLines <| theTree)
            ++ (List.map (svgLabel -1) << makeLabels <| theTree)
            ++ (List.map (svgLabel 2) << flipLabelsVertical << makeLabels <| theTree)
        )



-- rect
--     [ x "10"
--     , y "10"
--     , width "100"
--     , height "100"
--     , rx "15"
--     , ry "15"
--     , fill "red"
--     ]
--     []
--   ,
