module Tailwind exposing (tailwind)

import Html exposing (Attribute)
import Html.Attributes exposing (class)


tailwind : String -> Attribute msg
tailwind =
    class
