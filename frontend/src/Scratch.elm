module Main exposing (bottomSplits, firstLevelLine, firstSplit, secondLevelLines, secondSplit, secondSplitHeight, thirdLevelLines, thirdSplitHeight, thirdSplits)


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
