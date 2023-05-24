module Server.Main exposing (Model, Msg(..), init, main, update)

import App
import Apps exposing (Apps)
import Headers exposing (Headers)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode exposing (Value)
import Json.Encode as Encode
import Ports
import Ports.Log as Log
import Url exposing (Url)



-- MAIN


main : Program () Model Msg
main =
    Platform.worker { init = init, update = update, subscriptions = always subscriptions }



-- MODEL


type alias Model =
    { apps : Apps }


init : () -> ( Model, Cmd Msg )
init () =
    ( { apps = Apps.empty }
    , Ports.send Encode.null Receive
    )



-- UPDATE


type Msg
    = Http Int Url Headers
    | Error Decode.Error
    | Timeout Int
    | Msg Int App.Msg
    | Receive Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Http id url headers ->
            perform id model (Apps.insert id url headers model.apps)

        Error error ->
            ( model
            , Log.error (Decode.errorToString error)
            )

        Timeout id ->
            ( { model | apps = Apps.remove id model.apps }
            , Cmd.none
            )

        Msg id appMsg ->
            perform id model (Apps.update id appMsg model.apps)

        Receive value ->
            ( model, Cmd.none )


perform : Int -> Model -> ( Apps, Apps.Action ) -> ( Model, Cmd Msg )
perform id model ( apps, action ) =
    case action of
        Apps.Perform cmd ->
            ( { model | apps = apps }
            , Cmd.map (Msg id) cmd
            )

        Apps.View view appModel ->
            ( { model | apps = apps }
            , Ports.html id view appModel
            )


subscriptions : Sub Msg
subscriptions =
    Sub.batch
        [ Ports.http { onSuccess = Http, onError = Error }
        , Ports.cancel Timeout
        ]
