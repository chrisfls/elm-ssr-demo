module App exposing (Flags, Model, Msg(..), encoder, init, ready, subscriptions, title, update, view)

import Dual.Html exposing (..)
import Dual.Html.Attributes exposing (..)
import Dual.Html.Events exposing (onInput)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Encode as Encode



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }


type alias Flags =
    { model : Value }


init : Flags -> ( Model, Cmd Msg )
init flags =
    case Decode.decodeValue decoder flags.model of
        Ok (Just model) ->
            ( model, Cmd.none )

        Ok Nothing ->
            ( empty, Cmd.none )

        Err _ ->
            -- TODO: report error through a log port
            ( empty, Cmd.none )


empty : Model
empty =
    Model "" "" ""


decoder : Decoder (Maybe Model)
decoder =
    Decode.map3 Model
        (Decode.field "name" Decode.string)
        (Decode.field "password" Decode.string)
        (Decode.field "passwordAgain" Decode.string)
        |> Decode.nullable


encoder : Model -> Value
encoder model =
    Encode.object
        [ ( "name", Encode.string model.name )
        , ( "password", Encode.string model.password )
        , ( "passwordAgain", Encode.string model.passwordAgain )
        ]



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
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

        Noop ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


ready : Model -> Bool
ready _ =
    True


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
