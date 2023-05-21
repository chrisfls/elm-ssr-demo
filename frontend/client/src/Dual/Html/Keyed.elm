module Dual.Html.Keyed exposing (..)

import Dual.Html exposing (Attribute, Html)
import Html.Keyed


node : String -> List (Attribute msg) -> List ( String, Html msg ) -> Html msg
node =
    Html.Keyed.node


ol : List (Attribute msg) -> List ( String, Html msg ) -> Html msg
ol =
    Html.Keyed.ol


ul : List (Attribute msg) -> List ( String, Html msg ) -> Html msg
ul =
    Html.Keyed.ul
