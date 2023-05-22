module App exposing
    ( Model, init, reuse, encode
    , Msg(..), update, subscriptions
    , ready, title, view
    )

{-|

@docs Model, init, reuse, encode
@docs Msg, update, subscriptions
@docs ready, title, view

-}

import Dual.Html exposing (..)
import Dual.Html.Attributes exposing (..)
import Dual.Html.Events exposing (onInput)
import Graphql.Http
import Headers exposing (Headers)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Decode
import Json.Encode as Encode
import Query.User as User
import Request
import Url exposing (Url)



-- MODEL


type alias Model =
    { url : Url
    , headers : Headers
    , ready : Bool
    , name : String
    , password : String
    , passwordAgain : String
    }


init : Url -> Headers -> ( Model, Cmd Msg )
init url headers =
    ( { url = url
      , headers = headers
      , ready = False
      , name = ""
      , password = ""
      , passwordAgain = ""
      }
    , Request.query Loaded User.query
    )


reuse : Value -> Url -> ( Model, Cmd Msg )
reuse flags url =
    case Decode.decodeValue (decoder url) flags of
        Ok model ->
            ( model, Cmd.none )

        Err _ ->
            -- TODO: send error back
            init url Headers.empty


decoder : Url -> Decoder Model
decoder url =
    Decode.succeed Model
        |> Decode.hardcoded url
        |> Decode.required "headers" Headers.decoder
        |> Decode.required "ready" Decode.bool
        |> Decode.required "name" Decode.string
        |> Decode.required "password" Decode.string
        |> Decode.required "passwordAgain" Decode.string


encode : Model -> Value
encode model =
    Encode.object
        [ ( "headers", Headers.encoder model.headers )
        , ( "ready", Encode.bool model.ready )
        , ( "name", Encode.string model.name )
        , ( "password", Encode.string model.password )
        , ( "passwordAgain", Encode.string model.passwordAgain )
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
                | ready = True
                , name = data.name
                , password = data.password
                , passwordAgain = data.passwordAgain
              }
            , Cmd.none
            )

        Loaded (Err error) ->
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
    model.ready


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
