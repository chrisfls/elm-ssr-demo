module Main exposing (main)

import App
import Browser
import Browser.Navigation as Navigation
import Headers
import Json.Decode as Decode exposing (Value)
import Url exposing (Url)


main : Program Value App.Model App.Msg
main =
    Browser.application
        { init = init
        , update = App.update
        , view = view
        , subscriptions = App.subscriptions
        , onUrlChange = \_ -> App.Noop
        , onUrlRequest = \_ -> App.Noop
        }


init : Value -> Url -> Navigation.Key -> ( App.Model, Cmd App.Msg )
init flags _ _ =
    case Decode.decodeValue App.decoder flags of
        Ok model ->
            App.reuse model

        Err _ ->
            App.init "" Headers.empty


view : App.Model -> Browser.Document App.Msg
view model =
    { title = App.title model
    , body = [ App.view model ]
    }
