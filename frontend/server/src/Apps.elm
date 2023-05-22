module Apps exposing (Action(..), Apps, empty, insert, remove, update)

import App
import Headers exposing (Headers)
import Html.String
import IntDict exposing (IntDict)
import Json.Encode as Encode exposing (Value)
import Url exposing (Url)


type Apps
    = Apps Internal


type alias Internal =
    IntDict App.Model


type Action
    = Perform (Cmd App.Msg)
    | View String Value


empty : Apps
empty =
    Apps IntDict.empty


insert : Int -> Url -> Headers -> Apps -> ( Apps, Action )
insert id url headers (Apps dict) =
    ready id dict (App.init Encode.null url headers)


remove : Int -> Apps -> Apps
remove id (Apps dict) =
    Apps (IntDict.remove id dict)


update : Int -> App.Msg -> Apps -> ( Apps, Action )
update id msg ((Apps dict) as apps) =
    case IntDict.get id dict of
        Just model ->
            ready id dict (App.update msg model)

        Nothing ->
            ( apps
            , Perform Cmd.none
            )


ready : Int -> IntDict App.Model -> ( App.Model, Cmd App.Msg ) -> ( Apps, Action )
ready id dict ( model, cmd ) =
    if App.ready model then
        ( Apps (IntDict.remove id dict)
        , View (Html.String.toString 0 (App.view model)) (App.encode model)
        )

    else
        ( Apps (IntDict.insert id model dict)
        , Perform cmd
        )



-- No subscriptions here because it seems like it makes no sense to have'em
