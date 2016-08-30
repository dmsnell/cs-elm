module Pages.LoginScreen exposing (..)

import Html exposing (div, text)
import Html.App
import Task
import Tasks.AuthenticateUser exposing (AuthenticationTask, LoginInfo, requestLoginToken)
import Components.LoginDialog as Dialog


type Msg
    = FormMsg Dialog.Msg
    | LoginResponse (Result String LoginInfo)


type ChildMsg
    = SubmitLogin


type alias Model =
    { loginForm : Dialog.Model
    , error : Maybe String
    }


initialModel : Model
initialModel =
    { loginForm = Dialog.initialModel
    , error = Nothing
    }


fetchUserToken : AuthenticationTask -> Cmd Msg
fetchUserToken task =
    Task.perform LoginResponse LoginResponse task


update : Msg -> Model -> ( Model, Cmd Msg, Maybe LoginInfo )
update msg model =
    case msg of
        LoginResponse login ->
            case login of
                Ok info ->
                    ( { model | error = Nothing }, Cmd.none, Just info )

                Err error ->
                    ( { model | error = Just error }, Cmd.none, Nothing )

        FormMsg formMsg ->
            let
                ( loginForm, cmd ) =
                    Dialog.update
                        (fetchUserToken (requestLoginToken model.loginForm))
                        formMsg
                        model.loginForm
            in
                ( { model | loginForm = loginForm }, cmd, Nothing )


view : Model -> Html.Html Msg
view model =
    let
        errorMessage =
            case model.error of
                Nothing ->
                    Html.text ""

                Just e ->
                    div [] [ text e ]
    in
        div []
            [ renderForm model
            , errorMessage
            ]


renderForm : Model -> Html.Html Msg
renderForm model =
    Html.App.map FormMsg (Dialog.view model.loginForm)
