module About exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Html msg
view =
    div []
        [ p [] [ text "The information on this site comes from my doctural dissertation, etc.etc." ]
        ]
