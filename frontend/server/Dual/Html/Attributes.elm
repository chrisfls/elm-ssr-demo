module Dual.Html.Attributes exposing (..)

import Dual.Html exposing (Attribute)
import Html.String.Attributes as Attributes
import Json.Decode exposing (Value)


style : String -> String -> Attribute msg
style =
    Attributes.style


property : String -> Value -> Attribute msg
property =
    Attributes.property


attribute : String -> String -> Attribute msg
attribute =
    Attributes.attribute


map : (a -> msg) -> Attribute a -> Attribute msg
map =
    Attributes.map


class : String -> Attribute msg
class =
    Attributes.class


classList : List ( String, Bool ) -> Attribute msg
classList =
    Attributes.classList


id : String -> Attribute msg
id =
    Attributes.id


title : String -> Attribute msg
title =
    Attributes.title


hidden : Bool -> Attribute msg
hidden =
    Attributes.hidden


type_ : String -> Attribute msg
type_ =
    Attributes.type_


value : String -> Attribute msg
value =
    Attributes.value


checked : Bool -> Attribute msg
checked =
    Attributes.checked


placeholder : String -> Attribute msg
placeholder =
    Attributes.placeholder


selected : Bool -> Attribute msg
selected =
    Attributes.selected


accept : String -> Attribute msg
accept =
    Attributes.accept


acceptCharset : String -> Attribute msg
acceptCharset =
    Attributes.acceptCharset


action : String -> Attribute msg
action =
    Attributes.action


autocomplete : Bool -> Attribute msg
autocomplete =
    Attributes.autocomplete


autofocus : Bool -> Attribute msg
autofocus =
    Attributes.autofocus


disabled : Bool -> Attribute msg
disabled =
    Attributes.disabled


enctype : String -> Attribute msg
enctype =
    Attributes.enctype


list : String -> Attribute msg
list =
    Attributes.list


maxlength : Int -> Attribute msg
maxlength =
    Attributes.maxlength


minlength : Int -> Attribute msg
minlength =
    Attributes.minlength


method : String -> Attribute msg
method =
    Attributes.method


multiple : Bool -> Attribute msg
multiple =
    Attributes.multiple


name : String -> Attribute msg
name =
    Attributes.name


novalidate : Bool -> Attribute msg
novalidate =
    Attributes.novalidate


pattern : String -> Attribute msg
pattern =
    Attributes.pattern


readonly : Bool -> Attribute msg
readonly =
    Attributes.readonly


required : Bool -> Attribute msg
required =
    Attributes.required


size : Int -> Attribute msg
size =
    Attributes.size


for : String -> Attribute msg
for =
    Attributes.for


form : String -> Attribute msg
form =
    Attributes.form


max : String -> Attribute msg
max =
    Attributes.max


min : String -> Attribute msg
min =
    Attributes.min


step : String -> Attribute msg
step =
    Attributes.step


cols : Int -> Attribute msg
cols =
    Attributes.cols


rows : Int -> Attribute msg
rows =
    Attributes.rows


wrap : String -> Attribute msg
wrap =
    Attributes.wrap


href : String -> Attribute msg
href =
    Attributes.href


target : String -> Attribute msg
target =
    Attributes.target


download : String -> Attribute msg
download =
    Attributes.download


hreflang : String -> Attribute msg
hreflang =
    Attributes.hreflang


media : String -> Attribute msg
media =
    Attributes.media


ping : String -> Attribute msg
ping =
    Attributes.ping


rel : String -> Attribute msg
rel =
    Attributes.rel


ismap : Bool -> Attribute msg
ismap =
    Attributes.ismap


usemap : String -> Attribute msg
usemap =
    Attributes.usemap


shape : String -> Attribute msg
shape =
    Attributes.shape


coords : String -> Attribute msg
coords =
    Attributes.coords


src : String -> Attribute msg
src =
    Attributes.src


height : Int -> Attribute msg
height =
    Attributes.height


width : Int -> Attribute msg
width =
    Attributes.width


alt : String -> Attribute msg
alt =
    Attributes.alt


autoplay : Bool -> Attribute msg
autoplay =
    Attributes.autoplay


controls : Bool -> Attribute msg
controls =
    Attributes.controls


loop : Bool -> Attribute msg
loop =
    Attributes.loop


preload : String -> Attribute msg
preload =
    Attributes.preload


poster : String -> Attribute msg
poster =
    Attributes.poster


default : Bool -> Attribute msg
default =
    Attributes.default


kind : String -> Attribute msg
kind =
    Attributes.kind


srclang : String -> Attribute msg
srclang =
    Attributes.srclang


sandbox : String -> Attribute msg
sandbox =
    Attributes.sandbox


srcdoc : String -> Attribute msg
srcdoc =
    Attributes.srcdoc


reversed : Bool -> Attribute msg
reversed =
    Attributes.reversed


start : Int -> Attribute msg
start =
    Attributes.start


align : String -> Attribute msg
align =
    Attributes.align


colspan : Int -> Attribute msg
colspan =
    Attributes.colspan


rowspan : Int -> Attribute msg
rowspan =
    Attributes.rowspan


headers : String -> Attribute msg
headers =
    Attributes.headers


scope : String -> Attribute msg
scope =
    Attributes.scope


accesskey : Char -> Attribute msg
accesskey =
    Attributes.accesskey


contenteditable : Bool -> Attribute msg
contenteditable =
    Attributes.contenteditable


contextmenu : String -> Attribute msg
contextmenu =
    Attributes.contextmenu


dir : String -> Attribute msg
dir =
    Attributes.dir


draggable : String -> Attribute msg
draggable =
    Attributes.draggable


dropzone : String -> Attribute msg
dropzone =
    Attributes.dropzone


itemprop : String -> Attribute msg
itemprop =
    Attributes.itemprop


lang : String -> Attribute msg
lang =
    Attributes.lang


spellcheck : Bool -> Attribute msg
spellcheck =
    Attributes.spellcheck


tabindex : Int -> Attribute msg
tabindex =
    Attributes.tabindex


cite : String -> Attribute msg
cite =
    Attributes.cite


datetime : String -> Attribute msg
datetime =
    Attributes.datetime


pubdate : String -> Attribute msg
pubdate =
    Attributes.pubdate


manifest : String -> Attribute msg
manifest =
    Attributes.manifest
