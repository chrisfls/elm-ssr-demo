module Main exposing (main)

import App
import Browser
import Browser.Navigation as Navigation
import Url exposing (Url)


main : Program App.Flags App.Model App.Msg
main =
    Browser.application
        { init = init
        , update = App.update
        , view = view
        , subscriptions = App.subscriptions
        , onUrlChange = \_ -> App.Noop
        , onUrlRequest = \_ -> App.Noop
        }


init : App.Flags -> Url -> Navigation.Key -> ( App.Model, Cmd App.Msg )
init flags _ _ =
    App.init flags


view : App.Model -> Browser.Document App.Msg
view model =
    { title = App.title model
    , body = [ App.view model ]
    }
