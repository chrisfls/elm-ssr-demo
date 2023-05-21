module Headers exposing (..)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)

type alias Headers =
    Dict String (List String)


decoder : Decoder Headers
decoder =
  Decode.dict (Decode.list Decode.string)
