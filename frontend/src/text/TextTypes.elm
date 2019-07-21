module Text.TextTypes exposing (Paragraph, Section)


type alias Section =
    { title : String, id : String, level : Int }


type alias Paragraph =
    { text : String, commentary : String }
