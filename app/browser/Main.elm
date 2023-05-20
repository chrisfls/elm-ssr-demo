module Main exposing (main)

import App
import Browser


main : Program () App.Model App.Msg
main =
    Browser.application
        { init = \flags _ _ -> App.init flags
        , update = App.update
        , view =
            \model ->
                { title = App.title model
                , body = [ App.view model ]
                }
        , subscriptions = App.subscriptions
        , onUrlChange = \_ -> App.Noop
        , onUrlRequest = \_ -> App.Noop
        }
