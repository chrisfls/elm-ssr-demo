module Dual.Html.Events exposing (..)

import Dual.Html exposing (Attribute)
import Html.String.Events as Events
import Json.Decode exposing (Decoder)


onClick : msg -> Attribute msg
onClick =
    Events.onClick


onDoubleClick : msg -> Attribute msg
onDoubleClick =
    Events.onDoubleClick


onMouseDown : msg -> Attribute msg
onMouseDown =
    Events.onMouseDown


onMouseUp : msg -> Attribute msg
onMouseUp =
    Events.onMouseUp


onMouseEnter : msg -> Attribute msg
onMouseEnter =
    Events.onMouseEnter


onMouseLeave : msg -> Attribute msg
onMouseLeave =
    Events.onMouseLeave


onMouseOver : msg -> Attribute msg
onMouseOver =
    Events.onMouseOver


onMouseOut : msg -> Attribute msg
onMouseOut =
    Events.onMouseOut


onInput : (String -> msg) -> Attribute msg
onInput =
    Events.onInput


onCheck : (Bool -> msg) -> Attribute msg
onCheck =
    Events.onCheck


onSubmit : msg -> Attribute msg
onSubmit =
    Events.onSubmit


onBlur : msg -> Attribute msg
onBlur =
    Events.onBlur


onFocus : msg -> Attribute msg
onFocus =
    Events.onFocus


on : String -> Decoder msg -> Attribute msg
on =
    Events.on


stopPropagationOn : String -> Decoder ( msg, Bool ) -> Attribute msg
stopPropagationOn =
    Events.stopPropagationOn


preventDefaultOn : String -> Decoder ( msg, Bool ) -> Attribute msg
preventDefaultOn =
    Events.preventDefaultOn


custom : String -> Decoder { message : msg, stopPropagation : Bool, preventDefault : Bool } -> Attribute msg
custom =
    Events.custom


targetValue : Decoder String
targetValue =
    Events.targetValue


targetChecked : Decoder Bool
targetChecked =
    Events.targetChecked


keyCode : Decoder Int
keyCode =
    Events.keyCode
