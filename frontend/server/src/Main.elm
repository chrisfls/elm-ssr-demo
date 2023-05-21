module Main exposing (Model, Msg(..), init, main, update)

import App
import Apps exposing (Apps)
import Headers exposing (Headers)
import Html exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as Decode
import Ports



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
    , Cmd.none
    )



-- UPDATE


type Msg
    = Http Int String Headers
    | Error Int Decode.Error
    | Timeout Int
    | Msg Int App.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Http id url headers ->
            perform id model (Apps.insert id url headers model.apps)

        Error id error ->
            ( { model | apps = Apps.remove id model.apps }
            , Ports.error id error
            )

        Timeout id ->
            ( { model | apps = Apps.remove id model.apps }
            , Cmd.none
            )

        Msg id appMsg ->
            perform id model (Apps.update id appMsg model.apps)


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
        , Ports.timeout Timeout
        ]
