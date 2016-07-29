module Pages.LoginScreen exposing (..)

import Html exposing (div, text)
import Html.App

import Components.LoginDialog as Dialog


type Msg
  = FormMsg Dialog.Msg


type alias Model
  = { loginForm : Dialog.Model
    }


initialModel : Model
initialModel
  = { loginForm = Dialog.initialModel
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    FormMsg formMsg ->
      let
        ( loginForm, cmd ) = Dialog.update formMsg model.loginForm

      in
        ( { model | loginForm = loginForm }, Cmd.map FormMsg cmd )


view : Model -> Html.Html Msg
view model =
  div []
      [ renderForm model ]


renderForm : Model -> Html.Html Msg
renderForm model =
  Html.App.map FormMsg (Dialog.view model.loginForm)
