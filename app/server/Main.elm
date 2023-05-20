port module Main exposing (Model, Msg(..), init, main, update)

import Html exposing (..)
import Html.Attributes exposing (..)
import App
import IntDict exposing (IntDict)

port http : ({ id: Int, url: String } -> msg) -> Sub msg

port html : { id: Int, html: String } -> Cmd msg

-- MAIN


main : Program () Model Msg
main =
    Platform.worker { init = init, update = update, subscriptions = subscriptions }


-- MODEL


type alias Model =
    { models : IntDict App.Model
    }


init : () -> ( Model , Cmd Msg )
init () =
    ( { models = IntDict.empty }, Cmd.none )



-- UPDATE


type Msg
    = Request { id: Int, url: String }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Request { id, url } ->
            -- Application.init
            ( model, html { id = id, html = "Hello, World!"} )


subscriptions : Model -> Sub Msg
subscriptions _ =
    http Request
