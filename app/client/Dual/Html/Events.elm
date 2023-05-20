module Dual.Html.Events exposing (..)

import Dual.Html exposing (Attribute)
import Html.Events
import Json.Decode exposing (Decoder)


onClick : msg -> Attribute msg
onClick =
    Html.Events.onClick


onDoubleClick : msg -> Attribute msg
onDoubleClick =
    Html.Events.onDoubleClick


onMouseDown : msg -> Attribute msg
onMouseDown =
    Html.Events.onMouseDown


onMouseUp : msg -> Attribute msg
onMouseUp =
    Html.Events.onMouseUp


onMouseEnter : msg -> Attribute msg
onMouseEnter =
    Html.Events.onMouseEnter


onMouseLeave : msg -> Attribute msg
onMouseLeave =
    Html.Events.onMouseLeave


onMouseOver : msg -> Attribute msg
onMouseOver =
    Html.Events.onMouseOver


onMouseOut : msg -> Attribute msg
onMouseOut =
    Html.Events.onMouseOut


onInput : (String -> msg) -> Attribute msg
onInput =
    Html.Events.onInput


onCheck : (Bool -> msg) -> Attribute msg
onCheck =
    Html.Events.onCheck


onSubmit : msg -> Attribute msg
onSubmit =
    Html.Events.onSubmit


onBlur : msg -> Attribute msg
onBlur =
    Html.Events.onBlur


onFocus : msg -> Attribute msg
onFocus =
    Html.Events.onFocus


on : String -> Decoder msg -> Attribute msg
on =
    Html.Events.on


stopPropagationOn : String -> Decoder ( msg, Bool ) -> Attribute msg
stopPropagationOn =
    Html.Events.stopPropagationOn


preventDefaultOn : String -> Decoder ( msg, Bool ) -> Attribute msg
preventDefaultOn =
    Html.Events.preventDefaultOn


custom : String -> Decoder { message : msg, stopPropagation : Bool, preventDefault : Bool } -> Attribute msg
custom =
    Html.Events.custom


targetValue : Decoder String
targetValue =
    Html.Events.targetValue


targetChecked : Decoder Bool
targetChecked =
    Html.Events.targetChecked


keyCode : Decoder Int
keyCode =
    Html.Events.keyCode
