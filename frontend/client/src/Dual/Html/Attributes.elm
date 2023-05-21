module Dual.Html.Attributes exposing (..)

import Dual.Html exposing (Attribute)
import Html.Attributes
import Json.Decode exposing (Value)


style : String -> String -> Attribute msg
style =
    Html.Attributes.style


property : String -> Value -> Attribute msg
property =
    Html.Attributes.property


attribute : String -> String -> Attribute msg
attribute =
    Html.Attributes.attribute


map : (a -> msg) -> Attribute a -> Attribute msg
map =
    Html.Attributes.map


class : String -> Attribute msg
class =
    Html.Attributes.class


classList : List ( String, Bool ) -> Attribute msg
classList =
    Html.Attributes.classList


id : String -> Attribute msg
id =
    Html.Attributes.id


title : String -> Attribute msg
title =
    Html.Attributes.title


hidden : Bool -> Attribute msg
hidden =
    Html.Attributes.hidden


type_ : String -> Attribute msg
type_ =
    Html.Attributes.type_


value : String -> Attribute msg
value =
    Html.Attributes.value


checked : Bool -> Attribute msg
checked =
    Html.Attributes.checked


placeholder : String -> Attribute msg
placeholder =
    Html.Attributes.placeholder


selected : Bool -> Attribute msg
selected =
    Html.Attributes.selected


accept : String -> Attribute msg
accept =
    Html.Attributes.accept


acceptCharset : String -> Attribute msg
acceptCharset =
    Html.Attributes.acceptCharset


action : String -> Attribute msg
action =
    Html.Attributes.action


autocomplete : Bool -> Attribute msg
autocomplete =
    Html.Attributes.autocomplete


autofocus : Bool -> Attribute msg
autofocus =
    Html.Attributes.autofocus


disabled : Bool -> Attribute msg
disabled =
    Html.Attributes.disabled


enctype : String -> Attribute msg
enctype =
    Html.Attributes.enctype


list : String -> Attribute msg
list =
    Html.Attributes.list


maxlength : Int -> Attribute msg
maxlength =
    Html.Attributes.maxlength


minlength : Int -> Attribute msg
minlength =
    Html.Attributes.minlength


method : String -> Attribute msg
method =
    Html.Attributes.method


multiple : Bool -> Attribute msg
multiple =
    Html.Attributes.multiple


name : String -> Attribute msg
name =
    Html.Attributes.name


novalidate : Bool -> Attribute msg
novalidate =
    Html.Attributes.novalidate


pattern : String -> Attribute msg
pattern =
    Html.Attributes.pattern


readonly : Bool -> Attribute msg
readonly =
    Html.Attributes.readonly


required : Bool -> Attribute msg
required =
    Html.Attributes.required


size : Int -> Attribute msg
size =
    Html.Attributes.size


for : String -> Attribute msg
for =
    Html.Attributes.for


form : String -> Attribute msg
form =
    Html.Attributes.form


max : String -> Attribute msg
max =
    Html.Attributes.max


min : String -> Attribute msg
min =
    Html.Attributes.min


step : String -> Attribute msg
step =
    Html.Attributes.step


cols : Int -> Attribute msg
cols =
    Html.Attributes.cols


rows : Int -> Attribute msg
rows =
    Html.Attributes.rows


wrap : String -> Attribute msg
wrap =
    Html.Attributes.wrap


href : String -> Attribute msg
href =
    Html.Attributes.href


target : String -> Attribute msg
target =
    Html.Attributes.target


download : String -> Attribute msg
download =
    Html.Attributes.download


hreflang : String -> Attribute msg
hreflang =
    Html.Attributes.hreflang


media : String -> Attribute msg
media =
    Html.Attributes.media


ping : String -> Attribute msg
ping =
    Html.Attributes.ping


rel : String -> Attribute msg
rel =
    Html.Attributes.rel


ismap : Bool -> Attribute msg
ismap =
    Html.Attributes.ismap


usemap : String -> Attribute msg
usemap =
    Html.Attributes.usemap


shape : String -> Attribute msg
shape =
    Html.Attributes.shape


coords : String -> Attribute msg
coords =
    Html.Attributes.coords


src : String -> Attribute msg
src =
    Html.Attributes.src


height : Int -> Attribute msg
height =
    Html.Attributes.height


width : Int -> Attribute msg
width =
    Html.Attributes.width


alt : String -> Attribute msg
alt =
    Html.Attributes.alt


autoplay : Bool -> Attribute msg
autoplay =
    Html.Attributes.autoplay


controls : Bool -> Attribute msg
controls =
    Html.Attributes.controls


loop : Bool -> Attribute msg
loop =
    Html.Attributes.loop


preload : String -> Attribute msg
preload =
    Html.Attributes.preload


poster : String -> Attribute msg
poster =
    Html.Attributes.poster


default : Bool -> Attribute msg
default =
    Html.Attributes.default


kind : String -> Attribute msg
kind =
    Html.Attributes.kind


srclang : String -> Attribute msg
srclang =
    Html.Attributes.srclang


sandbox : String -> Attribute msg
sandbox =
    Html.Attributes.sandbox


srcdoc : String -> Attribute msg
srcdoc =
    Html.Attributes.srcdoc


reversed : Bool -> Attribute msg
reversed =
    Html.Attributes.reversed


start : Int -> Attribute msg
start =
    Html.Attributes.start


align : String -> Attribute msg
align =
    Html.Attributes.align


colspan : Int -> Attribute msg
colspan =
    Html.Attributes.colspan


rowspan : Int -> Attribute msg
rowspan =
    Html.Attributes.rowspan


headers : String -> Attribute msg
headers =
    Html.Attributes.headers


scope : String -> Attribute msg
scope =
    Html.Attributes.scope


accesskey : Char -> Attribute msg
accesskey =
    Html.Attributes.accesskey


contenteditable : Bool -> Attribute msg
contenteditable =
    Html.Attributes.contenteditable


contextmenu : String -> Attribute msg
contextmenu =
    Html.Attributes.contextmenu


dir : String -> Attribute msg
dir =
    Html.Attributes.dir


draggable : String -> Attribute msg
draggable =
    Html.Attributes.draggable


dropzone : String -> Attribute msg
dropzone =
    Html.Attributes.dropzone


itemprop : String -> Attribute msg
itemprop =
    Html.Attributes.itemprop


lang : String -> Attribute msg
lang =
    Html.Attributes.lang


spellcheck : Bool -> Attribute msg
spellcheck =
    Html.Attributes.spellcheck


tabindex : Int -> Attribute msg
tabindex =
    Html.Attributes.tabindex


cite : String -> Attribute msg
cite =
    Html.Attributes.cite


datetime : String -> Attribute msg
datetime =
    Html.Attributes.datetime


pubdate : String -> Attribute msg
pubdate =
    Html.Attributes.pubdate


manifest : String -> Attribute msg
manifest =
    Html.Attributes.manifest
