port module Log exposing
    ( debug
    , error
    , info
    , log
    , trace
    , warn
    )

import Json.Encode as Encode exposing (Value)


debug : String -> Cmd msg
debug =
    logger "debug"


error : String -> Cmd msg
error =
    logger "error"


info : String -> Cmd msg
info =
    logger "info"


log : String -> Cmd msg
log =
    logger "log"


trace : String -> Cmd msg
trace =
    logger "trace"


warn : String -> Cmd msg
warn =
    logger "warn"


logger : String -> String -> Cmd msg
logger level message =
    Encode.object
        [ ( "level", Encode.string level )
        , ( "message", Encode.string message )
        ]
        |> loggerPort


port loggerPort : Value -> Cmd msg
