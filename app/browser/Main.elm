module Main exposing (main)

import Browser
import Entrypoint


main : Program () Entrypoint.Model Entrypoint.Msg
main =
    Browser.application
        { init = \flags _ _ -> Entrypoint.init flags
        , update = Entrypoint.update
        , view =
            \model ->
                { title = "Title"
                , body = [ Entrypoint.view model ]
                }
        , subscriptions = \_ -> Sub.none
        , onUrlChange = \_ -> Entrypoint.Noop
        , onUrlRequest = \_ -> Entrypoint.Noop
        }
