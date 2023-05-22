port module Ports exposing (cancel, html, http)

import Headers exposing (Headers)
import Json.Decode as Decode exposing (Value)
import Json.Decode.Pipeline as Decode
import Url exposing (Url)



-- COMMANDS


port htmlPort : { id : Int, view : String, model : Value } -> Cmd msg


html : Int -> String -> Value -> Cmd msg
html id view model =
    htmlPort { id = id, view = view, model = model }



-- SUBSCRIPTIONS


port httpPort : (Value -> msg) -> Sub msg


http :
    { onSuccess : Int -> Url -> Headers -> msg
    , onError : Decode.Error -> msg
    }
    -> Sub msg
http { onSuccess, onError } =
    httpPort (httpHandler onSuccess onError)


httpHandler :
    (Int -> Url -> Headers -> msg)
    -> (Decode.Error -> msg)
    -> Value
    -> msg
httpHandler onSuccess onError value =
    case Decode.decodeValue httpDecoder value of
        Ok { id, url, headers } ->
            onSuccess id url headers

        Err reason ->
            onError reason


httpDecoder : Decode.Decoder { id : Int, url : Url, headers : Headers }
httpDecoder =
    Decode.succeed (\id url headers -> { id = id, url = url, headers = headers })
        |> Decode.required "id" Decode.int
        |> Decode.required "url"
            (Decode.andThen
                (Url.fromString
                    >> Maybe.map Decode.succeed
                    >> Maybe.withDefault (Decode.fail "Invalid url")
                )
                Decode.string
            )
        |> Decode.required "headers" Headers.decoder


port cancelPort : ({ id : Int } -> msg) -> Sub msg


cancel : (Int -> msg) -> Sub msg
cancel msg =
    cancelPort (.id >> msg)
