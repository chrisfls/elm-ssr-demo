module Request exposing (query)

import Dual.Html exposing (..)
import Dual.Html.Attributes exposing (..)
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet)


query :
    (Result (Graphql.Http.Error decodesTo) decodesTo -> msg)
    -> SelectionSet decodesTo RootQuery
    -> Cmd msg
query msg =
    Graphql.Http.queryRequest "http://localhost:4000/api"
        >> Graphql.Http.send msg
