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
                { title = "Title"
                , body = [ App.view model ]
                }
        , subscriptions = \_ -> Sub.none
        , onUrlChange = \_ -> App.Noop
        , onUrlRequest = \_ -> App.Noop
        }
