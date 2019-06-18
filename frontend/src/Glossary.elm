module Glossary exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Html msg
view =
    div
        []
        [ p [] [ text "Put important terms here." ]
        ]
