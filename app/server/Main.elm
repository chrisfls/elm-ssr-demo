port module Main exposing (Model, Msg(..), init, main, update, view, viewInput, viewValidation)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


-- MAIN


main =
    Platform.worker { init = init, update = update, subscriptions = subscriptions }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }


init () =
    (Model "" "" "", Cmd.none )



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Request { id: Int, url: String }


update msg model =
    case msg of
        Name name ->
            ({ model | name = name }, Cmd.none)

        Password password ->
            ({ model | password = password }, Cmd.none)

        PasswordAgain password ->
            ({ model | passwordAgain = password }, Cmd.none)

        Request { id, url } ->
            ( model, html { id = id, html = "Hello, World!"} )



-- VIEW


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


subscriptions : Model -> Sub Msg
subscriptions _ =
    http Request

port http : ({ id: Int, url: String } -> msg) -> Sub msg

port html : { id: Int, html: String } -> Cmd msg
