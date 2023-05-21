module App exposing (Flags, Model, Msg(..), encoder, init, ready, subscriptions, title, update, view)

import Dual.Html exposing (..)
import Dual.Html.Attributes exposing (..)
import Dual.Html.Events exposing (onInput)
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet exposing (SelectionSet)
import Headers exposing (Headers)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Encode as Encode
import Query.User as User



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , loaded : Bool
    , headers : Headers
    }



-- TODO: Unionize as
--          | Init { url: string, headers : Headers }
--          | Cont Value


type alias Flags =
    { model : Value, url : Maybe String, headers : Maybe Headers }


init : Flags -> ( Model, Cmd Msg )
init flags =
    case Decode.decodeValue decoder flags.model of
        Ok (Just model) ->
            ( model, Cmd.none )

        Ok Nothing ->
            load flags.headers

        Err _ ->
            -- TODO: report error through a log port
            load flags.headers


load : Maybe Headers -> ( Model, Cmd Msg )
load headers =
    ( empty (Maybe.withDefault Headers.empty headers)
    , requestQuery Loaded User.query
    )


empty : Headers -> Model
empty headers =
    { name = ""
    , password = ""
    , passwordAgain = ""
    , loaded = False
    , headers = headers
    }


decoder : Decoder (Maybe Model)
decoder =
    Decode.map5 Model
        (Decode.field "name" Decode.string)
        (Decode.field "password" Decode.string)
        (Decode.field "passwordAgain" Decode.string)
        (Decode.field "loaded" Decode.bool)
        (Decode.field "headers" Headers.decoder)
        |> Decode.nullable


encoder : Model -> Value
encoder model =
    Encode.object
        [ ( "name", Encode.string model.name )
        , ( "password", Encode.string model.password )
        , ( "passwordAgain", Encode.string model.passwordAgain )
        , ( "loaded", Encode.bool model.loaded )
        , ( "headers", Headers.encoder model.headers )
        ]



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Loaded (Result (Graphql.Http.Error User.Data) User.Data)
    | Noop


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Name name ->
            ( { model | name = name }, Cmd.none )

        Password password ->
            ( { model | password = password }, Cmd.none )

        PasswordAgain password ->
            ( { model | passwordAgain = password }, Cmd.none )

        Loaded (Ok data) ->
            ( { model
                | name = data.name
                , password = data.password
                , passwordAgain = data.passwordAgain
                , loaded = True
              }
            , Cmd.none
            )

        Loaded _ ->
            -- TODO: report error through log port
            ( model, Cmd.none )

        Noop ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


ready : Model -> Bool
ready model =
    model.loaded


title : Model -> String
title _ =
    "Example Title"


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "password" "Password" model.password Password
        , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
        , viewValidation model
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


viewValidation : Model -> Html msg
viewValidation model =
    if model.password == model.passwordAgain then
        div [ style "color" "green" ] [ text "OK" ]

    else
        div [ style "color" "red" ] [ text "Passwords do not match!" ]



-- COMMANDS


requestQuery :
    (Result (Graphql.Http.Error decodesTo) decodesTo -> msg)
    -> SelectionSet decodesTo RootQuery
    -> Cmd msg
requestQuery msg =
    Graphql.Http.queryRequest "http://localhost:4000"
        >> Graphql.Http.send msg
