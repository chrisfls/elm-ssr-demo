module Server.Html exposing (toString)

import Html exposing (Html)
import Json.Decode as Decode exposing (Value)
import Json.Encode as Encode
import Test.Html.Internal.ElmHtml.InternalTypes exposing (decodeElmHtml)
import Test.Html.Internal.ElmHtml.ToString exposing (defaultFormatOptions, nodeToStringWithOptions)
import VirtualDom


toString : Html msg -> Result String String
toString html =
    case
        Decode.decodeValue
            (decodeElmHtml (\_ _ -> VirtualDom.Normal (Decode.succeed ())))
            (toJson html)
    of
        Ok elmHtml ->
            Ok (nodeToStringWithOptions defaultFormatOptions elmHtml)

        Err jsonError ->
            Err (Decode.errorToString jsonError)


toJson : Html msg -> Value
toJson _ =
    Encode.string "a7e4173c7ea41051bf56e286966e5acc195472204f0cf016ebbd94dde5f18ec7"
