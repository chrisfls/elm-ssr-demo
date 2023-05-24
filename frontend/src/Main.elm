module Main exposing (main)

import App
import Browser
import Browser.Navigation as Navigation
import Eff
import Json.Decode exposing (Value)
import Url exposing (Url)


type alias Model =
    { key : Navigation.Key, app : App.Model }


main : Program Value Model App.Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = .app >> App.subscriptions
        , onUrlChange = App.UrlChange
        , onUrlRequest = App.UrlRequest
        }


init : Value -> Url -> Navigation.Key -> ( Model, Cmd App.Msg )
init flags url key =
    let
        ( model, eff ) =
            App.reuse flags url
    in
    ( { key = key, app = model }
    , Eff.performNavigation key eff
    )


update : App.Msg -> Model -> ( Model, Cmd App.Msg )
update msg { key, app } =
    let
        ( model_, eff ) =
            App.update msg app
    in
    ( { key = key, app = model_ }
    , Eff.performNavigation key eff
    )


view : Model -> Browser.Document App.Msg
view { app } =
    { title = App.title app
    , body = [ App.view app ]
    }
