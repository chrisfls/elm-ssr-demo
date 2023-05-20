module Html.String.Keyed exposing (..)

import Html.Keyed
import Html.String exposing (Attribute, Html)


node : String -> List (Attribute msg) -> List ( String, Html msg ) -> Html msg
node =
    Html.Keyed.node


ol : List (Attribute msg) -> List ( String, Html msg ) -> Html msg
ol =
    Html.Keyed.ol


ul : List (Attribute msg) -> List ( String, Html msg ) -> Html msg
ul =
    Html.Keyed.ul
