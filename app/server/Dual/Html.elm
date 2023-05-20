module Dual.Html exposing (..)

import Html.String as Html


type alias Html msg =
    Html.Html msg


type alias Attribute msg =
    Html.Attribute msg


text : String -> Html msg
text =
    Html.text


node : String -> List (Attribute msg) -> List (Html msg) -> Html msg
node =
    Html.node


map : (a -> msg) -> Html a -> Html msg
map =
    Html.map


h1 : List (Attribute msg) -> List (Html msg) -> Html msg
h1 =
    Html.h1


h2 : List (Attribute msg) -> List (Html msg) -> Html msg
h2 =
    Html.h2


h3 : List (Attribute msg) -> List (Html msg) -> Html msg
h3 =
    Html.h3


h4 : List (Attribute msg) -> List (Html msg) -> Html msg
h4 =
    Html.h4


h5 : List (Attribute msg) -> List (Html msg) -> Html msg
h5 =
    Html.h5


h6 : List (Attribute msg) -> List (Html msg) -> Html msg
h6 =
    Html.h6


div : List (Attribute msg) -> List (Html msg) -> Html msg
div =
    Html.div


p : List (Attribute msg) -> List (Html msg) -> Html msg
p =
    Html.p


hr : List (Attribute msg) -> List (Html msg) -> Html msg
hr =
    Html.hr


pre : List (Attribute msg) -> List (Html msg) -> Html msg
pre =
    Html.pre


blockquote : List (Attribute msg) -> List (Html msg) -> Html msg
blockquote =
    Html.blockquote


span : List (Attribute msg) -> List (Html msg) -> Html msg
span =
    Html.span


a : List (Attribute msg) -> List (Html msg) -> Html msg
a =
    Html.a


code : List (Attribute msg) -> List (Html msg) -> Html msg
code =
    Html.code


em : List (Attribute msg) -> List (Html msg) -> Html msg
em =
    Html.em


strong : List (Attribute msg) -> List (Html msg) -> Html msg
strong =
    Html.strong


i : List (Attribute msg) -> List (Html msg) -> Html msg
i =
    Html.i


b : List (Attribute msg) -> List (Html msg) -> Html msg
b =
    Html.b


u : List (Attribute msg) -> List (Html msg) -> Html msg
u =
    Html.u


sub : List (Attribute msg) -> List (Html msg) -> Html msg
sub =
    Html.sub


sup : List (Attribute msg) -> List (Html msg) -> Html msg
sup =
    Html.sup


br : List (Attribute msg) -> List (Html msg) -> Html msg
br =
    Html.br


ol : List (Attribute msg) -> List (Html msg) -> Html msg
ol =
    Html.ol


ul : List (Attribute msg) -> List (Html msg) -> Html msg
ul =
    Html.ul


li : List (Attribute msg) -> List (Html msg) -> Html msg
li =
    Html.li


dl : List (Attribute msg) -> List (Html msg) -> Html msg
dl =
    Html.dl


dt : List (Attribute msg) -> List (Html msg) -> Html msg
dt =
    Html.dt


dd : List (Attribute msg) -> List (Html msg) -> Html msg
dd =
    Html.dd


img : List (Attribute msg) -> List (Html msg) -> Html msg
img =
    Html.img


iframe : List (Attribute msg) -> List (Html msg) -> Html msg
iframe =
    Html.iframe


canvas : List (Attribute msg) -> List (Html msg) -> Html msg
canvas =
    Html.canvas


math : List (Attribute msg) -> List (Html msg) -> Html msg
math =
    Html.math


form : List (Attribute msg) -> List (Html msg) -> Html msg
form =
    Html.form


input : List (Attribute msg) -> List (Html msg) -> Html msg
input =
    Html.input


textarea : List (Attribute msg) -> List (Html msg) -> Html msg
textarea =
    Html.textarea


button : List (Attribute msg) -> List (Html msg) -> Html msg
button =
    Html.button


select : List (Attribute msg) -> List (Html msg) -> Html msg
select =
    Html.select


option : List (Attribute msg) -> List (Html msg) -> Html msg
option =
    Html.option


section : List (Attribute msg) -> List (Html msg) -> Html msg
section =
    Html.section


nav : List (Attribute msg) -> List (Html msg) -> Html msg
nav =
    Html.nav


article : List (Attribute msg) -> List (Html msg) -> Html msg
article =
    Html.article


aside : List (Attribute msg) -> List (Html msg) -> Html msg
aside =
    Html.aside


header : List (Attribute msg) -> List (Html msg) -> Html msg
header =
    Html.header


footer : List (Attribute msg) -> List (Html msg) -> Html msg
footer =
    Html.footer


address : List (Attribute msg) -> List (Html msg) -> Html msg
address =
    Html.address


main_ : List (Attribute msg) -> List (Html msg) -> Html msg
main_ =
    Html.main_


figure : List (Attribute msg) -> List (Html msg) -> Html msg
figure =
    Html.figure


figcaption : List (Attribute msg) -> List (Html msg) -> Html msg
figcaption =
    Html.figcaption


table : List (Attribute msg) -> List (Html msg) -> Html msg
table =
    Html.table


caption : List (Attribute msg) -> List (Html msg) -> Html msg
caption =
    Html.caption


colgroup : List (Attribute msg) -> List (Html msg) -> Html msg
colgroup =
    Html.colgroup


col : List (Attribute msg) -> List (Html msg) -> Html msg
col =
    Html.col


tbody : List (Attribute msg) -> List (Html msg) -> Html msg
tbody =
    Html.tbody


thead : List (Attribute msg) -> List (Html msg) -> Html msg
thead =
    Html.thead


tfoot : List (Attribute msg) -> List (Html msg) -> Html msg
tfoot =
    Html.tfoot


tr : List (Attribute msg) -> List (Html msg) -> Html msg
tr =
    Html.tr


td : List (Attribute msg) -> List (Html msg) -> Html msg
td =
    Html.td


th : List (Attribute msg) -> List (Html msg) -> Html msg
th =
    Html.th


fieldset : List (Attribute msg) -> List (Html msg) -> Html msg
fieldset =
    Html.fieldset


legend : List (Attribute msg) -> List (Html msg) -> Html msg
legend =
    Html.legend


label : List (Attribute msg) -> List (Html msg) -> Html msg
label =
    Html.label


datalist : List (Attribute msg) -> List (Html msg) -> Html msg
datalist =
    Html.datalist


optgroup : List (Attribute msg) -> List (Html msg) -> Html msg
optgroup =
    Html.optgroup


output : List (Attribute msg) -> List (Html msg) -> Html msg
output =
    Html.output


progress : List (Attribute msg) -> List (Html msg) -> Html msg
progress =
    Html.progress


meter : List (Attribute msg) -> List (Html msg) -> Html msg
meter =
    Html.meter


audio : List (Attribute msg) -> List (Html msg) -> Html msg
audio =
    Html.audio


video : List (Attribute msg) -> List (Html msg) -> Html msg
video =
    Html.video


source : List (Attribute msg) -> List (Html msg) -> Html msg
source =
    Html.source


track : List (Attribute msg) -> List (Html msg) -> Html msg
track =
    Html.track


embed : List (Attribute msg) -> List (Html msg) -> Html msg
embed =
    Html.embed


object : List (Attribute msg) -> List (Html msg) -> Html msg
object =
    Html.object


param : List (Attribute msg) -> List (Html msg) -> Html msg
param =
    Html.param


ins : List (Attribute msg) -> List (Html msg) -> Html msg
ins =
    Html.ins


del : List (Attribute msg) -> List (Html msg) -> Html msg
del =
    Html.del


small : List (Attribute msg) -> List (Html msg) -> Html msg
small =
    Html.small


cite : List (Attribute msg) -> List (Html msg) -> Html msg
cite =
    Html.cite


dfn : List (Attribute msg) -> List (Html msg) -> Html msg
dfn =
    Html.dfn


abbr : List (Attribute msg) -> List (Html msg) -> Html msg
abbr =
    Html.abbr


time : List (Attribute msg) -> List (Html msg) -> Html msg
time =
    Html.time


var : List (Attribute msg) -> List (Html msg) -> Html msg
var =
    Html.var


samp : List (Attribute msg) -> List (Html msg) -> Html msg
samp =
    Html.samp


kbd : List (Attribute msg) -> List (Html msg) -> Html msg
kbd =
    Html.kbd


s : List (Attribute msg) -> List (Html msg) -> Html msg
s =
    Html.s


q : List (Attribute msg) -> List (Html msg) -> Html msg
q =
    Html.q


mark : List (Attribute msg) -> List (Html msg) -> Html msg
mark =
    Html.mark


ruby : List (Attribute msg) -> List (Html msg) -> Html msg
ruby =
    Html.ruby


rt : List (Attribute msg) -> List (Html msg) -> Html msg
rt =
    Html.rt


rp : List (Attribute msg) -> List (Html msg) -> Html msg
rp =
    Html.rp


bdi : List (Attribute msg) -> List (Html msg) -> Html msg
bdi =
    Html.bdi


bdo : List (Attribute msg) -> List (Html msg) -> Html msg
bdo =
    Html.bdo


wbr : List (Attribute msg) -> List (Html msg) -> Html msg
wbr =
    Html.wbr


details : List (Attribute msg) -> List (Html msg) -> Html msg
details =
    Html.details


summary : List (Attribute msg) -> List (Html msg) -> Html msg
summary =
    Html.summary


menuitem : List (Attribute msg) -> List (Html msg) -> Html msg
menuitem =
    Html.menuitem


menu : List (Attribute msg) -> List (Html msg) -> Html msg
menu =
    Html.menu
