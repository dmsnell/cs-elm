module Pages.LoginScreen exposing (..)

import Html exposing (div, text)
import Html.App
import Task exposing (Task)

import Tasks.AuthenticateUser exposing (requestLoginToken)

import Components.LoginDialog as Dialog
import Models.User exposing (User)


type Msg
  = FormMsg Dialog.Msg
  | FetchSuccess (Maybe User)
  | FetchError String

type ChildMsg
  = SubmitLogin

type alias Model
  = { loginForm : Dialog.Model
    , error : Maybe String
    , user : Maybe User
    }


initialModel : Model
initialModel
  = { loginForm = Dialog.initialModel
    , error = Nothing
    , user = Nothing
    }


fetchUserToken : Dialog.Model -> Cmd Msg
fetchUserToken model =
  Task.perform FetchError FetchSuccess (requestLoginToken model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    FormMsg formMsg ->
        let
          ( loginForm, action ) = Dialog.update SubmitLogin formMsg model.loginForm

        in case action of
            Just SubmitLogin ->
                ( { model | loginForm = loginForm }, fetchUserToken model.loginForm )

            Nothing ->
                ( { model | loginForm = loginForm }, Cmd.none )

    FetchSuccess user ->
      ( { model | user = user }, Cmd.none )

    FetchError error ->
      ( { model | error = Just error }, Cmd.none )


view : Model -> Html.Html Msg
view model =
  let error =
    case model.error of
      Nothing -> ""
      Just e -> e

  in
    div []
        [ renderForm model
        , div [] [ text error ]
        ]


renderForm : Model -> Html.Html Msg
renderForm model =
  Html.App.map FormMsg (Dialog.view model.loginForm)
