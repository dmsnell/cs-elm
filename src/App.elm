module App exposing (main)

import Html exposing (div, text)
import Html.App

import Models.User exposing (User)

import Pages.LoginScreen as LoginScreen
import Pages.UserHome as UserHome


type Msg
  = LoginMsg LoginScreen.Msg
  | UserMsg UserHome.Msg


type alias Model =
  { user : Maybe User
  , loginScreen : LoginScreen.Model
  }


initialModel : Model
initialModel =
  { user = Nothing
  , loginScreen = LoginScreen.initialModel
  }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoginMsg subMsg ->
      let
        ( loginScreen, cmd ) = LoginScreen.update subMsg model.loginScreen

      in
        ( { model | loginScreen = loginScreen, user = Just (User 42 "bob") }, Cmd.map LoginMsg cmd )

    UserMsg subMsg ->
      let
        ( user, cmd ) = UserHome.update subMsg model.user

      in
        ( { model | user = user }, Cmd.map UserMsg cmd )


view : Model -> Html.Html Msg
view model =
  case model.user of
    Just user -> renderUserHome model
    Nothing -> renderLoginScreen model


renderUserHome : Model -> Html.Html Msg
renderUserHome model =
  Html.App.map UserMsg (UserHome.view model.user)


renderLoginScreen : Model -> Html.Html Msg
renderLoginScreen model =
  Html.App.map LoginMsg (LoginScreen.view model.loginScreen)


main =
  Html.App.program
    { init = ( initialModel, Cmd.none )
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
