module TableOfContents exposing (sections)

import Commentary.ErsterTeil as ErsterTeil
import Text.TextTypes exposing (Section)


paragraph : String
paragraph =
    String.fromChar (Char.fromCode 167)


sections : List Section
sections =
    [ ErsterTeil.section
    ]
