module Dual.Html.Lazy exposing (..)

import Dual.Html exposing (Html)
import Html.Lazy


lazy : (a -> Html msg) -> a -> Html msg
lazy =
    Html.Lazy.lazy


lazy2 : (a -> b -> Html msg) -> a -> b -> Html msg
lazy2 =
    Html.Lazy.lazy2


lazy3 : (a -> b -> c -> Html msg) -> a -> b -> c -> Html msg
lazy3 =
    Html.Lazy.lazy3


lazy4 : (a -> b -> c -> d -> Html msg) -> a -> b -> c -> d -> Html msg
lazy4 =
    Html.Lazy.lazy4


lazy5 : (a -> b -> c -> d -> e -> Html msg) -> a -> b -> c -> d -> e -> Html msg
lazy5 =
    Html.Lazy.lazy5


lazy6 : (a -> b -> c -> d -> e -> f -> Html msg) -> a -> b -> c -> d -> e -> f -> Html msg
lazy6 =
    Html.Lazy.lazy6


lazy7 : (a -> b -> c -> d -> e -> f -> g -> Html msg) -> a -> b -> c -> d -> e -> f -> g -> Html msg
lazy7 =
    Html.Lazy.lazy7


lazy8 : (a -> b -> c -> d -> e -> f -> g -> h -> Html msg) -> a -> b -> c -> d -> e -> f -> g -> h -> Html msg
lazy8 =
    Html.Lazy.lazy8
