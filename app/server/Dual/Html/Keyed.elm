module Dual.Html.Keyed exposing (..)

import Dual.Html exposing (Attribute, Html)
import Html.String.Keyed as Keyed


node : String -> List (Attribute msg) -> List ( String, Html msg ) -> Html msg
node =
    Keyed.node


ol : List (Attribute msg) -> List ( String, Html msg ) -> Html msg
ol =
    Keyed.ol


ul : List (Attribute msg) -> List ( String, Html msg ) -> Html msg
ul =
    Keyed.ul
