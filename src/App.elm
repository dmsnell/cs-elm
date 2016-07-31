module App exposing (main)

import Html exposing (div, text)
import Html.App

import Models.User exposing (User)

import Pages.LoginScreen as LoginScreen
import Pages.UserHome as UserHome


type Msg
  = LoginMsg LoginScreen.Msg
  | UserMsg UserHome.Msg

type UserStatus
  = LoggedOut
  | LoggedIn User

type alias Model =
  { userStatus : UserStatus
  , user : UserHome.Model
  , loginScreen : LoginScreen.Model
  }


initialModel : Model
initialModel =
  { userStatus = LoggedOut
  , user = UserHome.initialModel
  , loginScreen = LoginScreen.initialModel
  }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    LoginMsg subMsg ->
      let
        ( loginScreen, cmd ) = LoginScreen.update subMsg model.loginScreen

        userStatus = case loginScreen.apiKey of
            Nothing -> LoggedOut
            Just apiKey -> LoggedIn (User 42 "Bob")

      in
        ( { model
            | loginScreen = loginScreen
            , userStatus = userStatus
            }, Cmd.map LoginMsg cmd )

    UserMsg subMsg ->
      if subMsg == UserHome.Logout

      then
        ( { model
            | userStatus = LoggedOut
            , user = UserHome.initialModel
            }, Cmd.none )

      else if subMsg == UserHome.ChangeUsername

      then
        case model.userStatus of
          LoggedOut -> ( model, Cmd.none )
          LoggedIn user ->
            ( { model
                | userStatus = LoggedIn { user | username = model.user.username }
                }, Cmd.none )

      else
        let
          ( user, cmd ) = UserHome.update subMsg model.user

        in
          ( { model | user = user }, Cmd.map UserMsg cmd )


view : Model -> Html.Html Msg
view model =
  case model.userStatus of
    LoggedIn user -> renderUserHome model.user user
    LoggedOut -> renderLoginScreen model.loginScreen


renderUserHome : UserHome.Model -> User -> Html.Html Msg
renderUserHome userModel user  =
      Html.App.map UserMsg (UserHome.view userModel user)


renderLoginScreen : LoginScreen.Model -> Html.Html Msg
renderLoginScreen model =
  Html.App.map LoginMsg (LoginScreen.view model)


main =
  Html.App.program
    { init = ( initialModel, Cmd.none )
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
