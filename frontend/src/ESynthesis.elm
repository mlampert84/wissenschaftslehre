module ESynthesis exposing (diagram)

import List.Extra
import Svg exposing (..)
import Svg.Attributes as Attributes exposing (..)


type alias Dimension =
    { width : Int
    , height : Int
    }


type alias Point =
    { x : Int
    , y : Int
    }


type alias Delta =
    { deltaX : Int
    , deltaY : Int
    }


type alias Leaf =
    Point


type Tree
    = Node Point Tree Tree
    | Leaf Point


newPointLeft : Point -> Delta -> Point
newPointLeft point delta =
    Point (point.x - delta.deltaX) (point.y - delta.deltaY)


newPointRight : Point -> Delta -> Point
newPointRight point delta =
    Point (point.x + delta.deltaX) (point.y - delta.deltaY)


makeTree : Point -> Delta -> Tree
makeTree point delta =
    Node point (Leaf (newPointLeft point delta)) (Leaf (newPointRight point delta))


type alias Line =
    { start : Point
    , end : Point
    }


makeLines : Tree -> List Line
makeLines tree =
    let
        treeRecurse point subTree =
            case subTree of
                Leaf subPoint ->
                    [ Line point subPoint ]

                Node subPoint subT1 subT2 ->
                    treeRecurse subPoint subT1 ++ treeRecurse subPoint subT1
    in
    case tree of
        Leaf _ ->
            []

        Node p t1 t2 ->
            treeRecurse p t1 ++ treeRecurse p t2



-- makeLines : Tree -> List Line
-- makeLines tree = case tree of
--         Leaf _ -> []


size : Dimension
size =
    Dimension 96 96


firstSplit : Point
firstSplit =
    Point (size.width // 2) 0


secondSplitHeight : Int
secondSplitHeight =
    size.height // 6


thirdSplitHeight : Int
thirdSplitHeight =
    size.height // 3


secondSplit : Point
secondSplit =
    Point (size.width // 4) secondSplitHeight


firstLevelLine : Line
firstLevelLine =
    Line firstSplit secondSplit


thirdSplits : List Point
thirdSplits =
    [ Point (size.width * 2 // 16) thirdSplitHeight
    , Point (size.width * 6 // 16) thirdSplitHeight
    ]


secondLevelLines : List Line
secondLevelLines =
    List.Extra.lift2 Line [ secondSplit ] thirdSplits


bottomSplits : List Point
bottomSplits =
    let
        makePoint fraction =
            Point (size.width * fraction // 16) (size.height // 2)
    in
    List.map makePoint [ 1, 3, 5, 7 ]


thirdLevelLines : List Line
thirdLevelLines =
    List.Extra.lift2 Line thirdSplits bottomSplits


dimensionsToString : String
dimensionsToString =
    "0 0 "
        ++ String.fromInt size.width
        ++ " "
        ++ String.fromInt size.height


blackLine : Line -> Svg msg
blackLine line =
    Svg.line
        [ Attributes.x1 (String.fromInt line.start.x)
        , Attributes.y1 (String.fromInt line.start.y)
        , Attributes.x2 (String.fromInt line.end.x)
        , Attributes.y2 (String.fromInt line.end.y)
        , stroke "black"
        ]
        []


diagram : Svg msg
diagram =
    svg
        [ width "400"
        , height "400"
        , viewBox dimensionsToString
        ]
        ([ blackLine firstLevelLine ]
            ++ List.map blackLine secondLevelLines
            ++ List.map blackLine thirdLevelLines
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
