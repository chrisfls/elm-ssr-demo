module Dual.Html.Lazy exposing (..)

import Dual.Html exposing (Html)
import Html.String.Lazy as Lazy


lazy : (a -> Html msg) -> a -> Html msg
lazy =
    Lazy.lazy


lazy2 : (a -> b -> Html msg) -> a -> b -> Html msg
lazy2 =
    Lazy.lazy2


lazy3 : (a -> b -> c -> Html msg) -> a -> b -> c -> Html msg
lazy3 =
    Lazy.lazy3


lazy4 : (a -> b -> c -> d -> Html msg) -> a -> b -> c -> d -> Html msg
lazy4 f x y z w =
    f x y z w


lazy5 : (a -> b -> c -> d -> e -> Html msg) -> a -> b -> c -> d -> e -> Html msg
lazy5 f x y z w  =
    f x y z w


lazy6 : (a -> b -> c -> d -> e -> f -> Html msg) -> a -> b -> c -> d -> e -> f -> Html msg
lazy6 f x y z w a  =
    f x y z w a


lazy7 : (a -> b -> c -> d -> e -> f -> g -> Html msg) -> a -> b -> c -> d -> e -> f -> g -> Html msg
lazy7 f x y z w a b =
    f x y z w a b


lazy8 : (a -> b -> c -> d -> e -> f -> g -> h -> Html msg) -> a -> b -> c -> d -> e -> f -> g -> h -> Html msg
lazy8 f x y z w a b c =
    f x y z w a b c
