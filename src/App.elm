module App exposing (main)

import Html exposing (div, text)
import Html.App
import Models.User exposing (User)
import Pages.LoginScreen as LoginScreen
import Pages.UserHome as UserHome
import Task exposing (Task)
import Tasks.AuthenticateUser exposing (AuthenticationTask, LoginInfo)


type Msg
    = LoginMsg LoginScreen.Msg
    | UserMsg UserHome.Msg
    | LoginResponse (Result String LoginInfo)


type AuthenticationStatus
    = LoggedOut
    | LoggedIn LoginInfo


type alias Model =
    { authStatus : AuthenticationStatus
    , user : UserHome.Model
    , loginScreen : LoginScreen.Model
    }


initialModel : Model
initialModel =
    { authStatus = LoggedOut
    , user = UserHome.initialModel
    , loginScreen = LoginScreen.initialModel
    }


fetchUserToken : AuthenticationTask -> Cmd Msg
fetchUserToken task =
    Task.perform LoginResponse LoginResponse task


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ loginScreen } as model) =
    case msg of
        LoginResponse login ->
            case login of
                Ok info ->
                    ( { model
                        | authStatus = LoggedIn info
                        , loginScreen = { loginScreen | error = Nothing }
                      }
                    , Cmd.none
                    )

                Err error ->
                    ( { model | loginScreen = { loginScreen | error = Just error } }, Cmd.none )

        LoginMsg subMsg ->
            let
                ( loginScreen, cmd ) =
                    LoginScreen.update subMsg model.loginScreen
            in
                case cmd of
                    Just task ->
                        ( model, fetchUserToken task )

                    Nothing ->
                        ( { model | loginScreen = loginScreen }, Cmd.none )

        UserMsg subMsg ->
            case subMsg of
                UserHome.Logout ->
                    ( { model
                        | authStatus = LoggedOut
                        , user = UserHome.initialModel
                        , loginScreen = LoginScreen.initialModel
                      }
                    , Cmd.none
                    )

                _ ->
                    let
                        ( user, cmd ) =
                            UserHome.update subMsg model.user
                    in
                        ( { model | user = user }, Cmd.map UserMsg cmd )


view : Model -> Html.Html Msg
view model =
    case model.authStatus of
        LoggedIn user ->
            renderUserHome model.user <| User 42 user.email

        LoggedOut ->
            renderLoginScreen model.loginScreen


renderUserHome : UserHome.Model -> User -> Html.Html Msg
renderUserHome userModel user =
    Html.App.map UserMsg (UserHome.view userModel user)


renderLoginScreen : LoginScreen.Model -> Html.Html Msg
renderLoginScreen model =
    Html.App.map LoginMsg (LoginScreen.view model)


main : Program Never
main =
    Html.App.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
