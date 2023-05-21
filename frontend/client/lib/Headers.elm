module Headers exposing (..)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)


type alias Headers =
    Dict String (List String)


empty : Headers
empty =
    Dict.empty


decoder : Decoder Headers
decoder =
    Decode.dict (Decode.list Decode.string)


encoder : Headers -> Value
encoder =
    Encode.dict
        identity
        (Encode.list Encode.string)
