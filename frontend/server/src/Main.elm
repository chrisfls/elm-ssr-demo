port module Main exposing (Model, Msg(..), init, main, update)

import App
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.String
import IntDict exposing (IntDict)
import Json.Decode exposing (Value)


port http : ({ id : Int, url : String, headers : Value } -> msg) -> Sub msg


port timeout : ({ id : Int } -> msg) -> Sub msg


port html : { id : Int, html : String } -> Cmd msg



-- MAIN


main : Program () Model Msg
main =
    Platform.worker { init = init, update = update, subscriptions = subscriptions }



-- MODEL


type alias Model =
    IntDict App.Model


init : () -> ( Model, Cmd Msg )
init () =
    ( IntDict.empty
    , Cmd.none
    )



-- UPDATE


type Msg
    = Http { id : Int, url : String, headers : Value }
    | Timeout { id : Int }
    | Msg Int App.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Http { id } ->
            updateApp id model (App.init ())

        Timeout { id } ->
            ( IntDict.remove id model
            , Cmd.none
            )

        Msg id appMsg ->
            case IntDict.get id model of
                Just app ->
                    updateApp id model (App.update appMsg app)

                Nothing ->
                    ( model, Cmd.none )


updateApp : Int -> IntDict App.Model -> ( App.Model, Cmd App.Msg ) -> ( IntDict App.Model, Cmd Msg )
updateApp id model ( app, cmd ) =
    if App.ready app then
        ( IntDict.remove id model
        , html
            { id = id
            , html = Html.String.toString 0 (App.view app)
            }
        )

    else
        ( IntDict.insert id app model
        , Cmd.map (Msg id) cmd
        )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ http Http
        , timeout Timeout
        ]
