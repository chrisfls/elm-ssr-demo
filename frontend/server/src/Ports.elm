port module Ports exposing (error, html, http, timeout)

import Headers exposing (Headers)
import Json.Decode as Decode exposing (Value)
import Json.Encode as Encode



-- COMMANDS


port htmlPort : { id : Int, view : String, model : Value } -> Cmd msg


html : Int -> String -> Value -> Cmd msg
html id view model =
    htmlPort { id = id, view = view, model = model }


port errorPort : Value -> Cmd msg


error : Int -> Decode.Error -> Cmd msg
error id decodeError =
    Encode.object
        [ ( "id", Encode.int id )
        , ( "reason", decodeErrorEncoder decodeError )
        ]
        |> errorPort


decodeErrorEncoder : Decode.Error -> Value
decodeErrorEncoder decodeError =
    case decodeError of
        Decode.Field _ _ ->
            Encode.null

        Decode.Index _ _ ->
            Encode.null

        Decode.OneOf _ ->
            Encode.null

        Decode.Failure _ _ ->
            Encode.null



-- SUBSCRIPTIONS


port httpPort : ({ id : Int, url : String, headers : Value } -> msg) -> Sub msg


http :
    { onSuccess : Int -> String -> Headers -> msg
    , onError : Int -> Decode.Error -> msg
    }
    -> Sub msg
http { onSuccess, onError } =
    httpPort (httpHandler onSuccess onError)


httpHandler :
    (Int -> String -> Headers -> msg)
    -> (Int -> Decode.Error -> msg)
    -> { id : Int, url : String, headers : Value }
    -> msg
httpHandler onSuccess onError { id, url, headers } =
    case Decode.decodeValue Headers.decoder headers of
        Ok decodedHeaders ->
            onSuccess id url decodedHeaders

        Err reason ->
            onError id reason


port timeoutPort : ({ id : Int } -> msg) -> Sub msg


timeout : (Int -> msg) -> Sub msg
timeout msg =
    timeoutPort (.id >> msg)
