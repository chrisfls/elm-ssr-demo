port module Main exposing (Model, Msg(..), init, main, update)

import Html exposing (..)
import Html.Attributes exposing (..)
import App
import IntDict exposing (IntDict)
import Html.String

port http : ({ id: Int, url: String } -> msg) -> Sub msg

port html : { id: Int, html: String } -> Cmd msg

-- MAIN


main : Program () Model Msg
main =
    Platform.worker { init = init, update = update, subscriptions = subscriptions }


-- MODEL


type alias Model =
     IntDict App.Model


init : () -> ( Model , Cmd Msg )
init () =
    ( IntDict.empty
    , Cmd.none
    )



-- UPDATE


type Msg
    = Request { id: Int, url: String }
    | Forward Int App.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Request { id, url } ->
            updateApp id model (App.init ())

        Forward id forward ->
            case IntDict.get id model of
                Just app ->
                    updateApp id model (App.update forward app)

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
        , Cmd.map (Forward id) cmd
        )



subscriptions : Model -> Sub Msg
subscriptions _ =
    http Request
