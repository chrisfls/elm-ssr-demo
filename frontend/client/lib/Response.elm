module Response exposing (Response)

import Graphql.Http


type alias Response decodesTo =
    Result (Graphql.Http.Error decodesTo) decodesTo
