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
  , user : Maybe UserHome.Model
  , loginScreen : LoginScreen.Model
  }


initialModel : Model
initialModel =
  { userStatus = LoggedOut
  , user = Nothing
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
            , user = Nothing
            }, Cmd.none )

      else
        case model.user of
          Nothing -> ( model, Cmd.none )

          Just oldUser ->
            let
              ( user, cmd ) = UserHome.update subMsg oldUser

            in
              ( { model | user = Just user }, Cmd.map UserMsg cmd )


view : Model -> Html.Html Msg
view model =
  case model.userStatus of
    LoggedIn user -> renderUserHome (UserHome.modelFor user)
    LoggedOut -> renderLoginScreen model


renderUserHome : UserHome.Model -> Html.Html Msg
renderUserHome user =
      Html.App.map UserMsg (UserHome.view user)


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
