module Eff exposing
    ( Eff, none, batch, map
    , perform, performNavigation
    , debug, error, info, log, trace, warn
    , query
    )

{-|

@docs Eff, none, batch, map
@docs perform, performNavigation

@docs debug, error, info, log, trace, warn
@docs query

-}

import Browser.Navigation as Navigation
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet)
import Ports.Log
import Response exposing (Response)


type Eff msg
    = EffForCmd (Cmd msg)
    | EffForNav (Navigation.Key -> Cmd msg)
    | EffBatch (List (Eff msg))


none : Eff msg
none =
    EffForCmd Cmd.none


batch : List (Eff msg) -> Eff msg
batch =
    EffBatch


map : (a -> msg) -> Eff a -> Eff msg
map mapper effect =
    case effect of
        EffForCmd cmd ->
            EffForCmd (Cmd.map mapper cmd)

        EffForNav f ->
            EffForNav (\key -> Cmd.map mapper (f key))

        EffBatch xs ->
            EffBatch (List.map (map mapper) xs)



-- COMMAND


perform : Eff msg -> Cmd msg
perform effect =
    case effect of
        EffForCmd cmd ->
            cmd

        EffForNav _ ->
            Cmd.none

        EffBatch effects ->
            Cmd.batch (List.map perform effects)


performNavigation : Navigation.Key -> Eff msg -> Cmd msg
performNavigation key effect =
    case effect of
        EffForNav f ->
            f key

        EffBatch effects ->
            Cmd.batch (List.map (performNavigation key) effects)

        _ ->
            perform effect



-- EFFECTS


debug : String -> Eff msg
debug =
    Ports.Log.debug >> EffForCmd


error : String -> Eff msg
error =
    Ports.Log.error >> EffForCmd


info : String -> Eff msg
info =
    Ports.Log.info >> EffForCmd


log : String -> Eff msg
log =
    Ports.Log.log >> EffForCmd


trace : String -> Eff msg
trace =
    Ports.Log.trace >> EffForCmd


warn : String -> Eff msg
warn =
    Ports.Log.warn >> EffForCmd


query :
    (Response decodesTo -> msg)
    -> SelectionSet decodesTo RootQuery
    -> Eff msg
query msg =
    Graphql.Http.queryRequest "http://localhost:4000/api"
        >> Graphql.Http.send msg
        >> EffForCmd
