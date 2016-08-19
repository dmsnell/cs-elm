module App exposing (main)

import Html exposing (div, text)
import Html.App
import Models.User exposing (User)
import Pages.LoginScreen as LoginScreen
import Pages.UserHome as UserHome
import Tasks.AuthenticateUser exposing (LoginInfo)


type Msg
    = LoginMsg LoginScreen.Msg
    | UserMsg UserHome.Msg


type AuthenticationStatus
    = LoggedOut
    | LoggedIn LoginInfo


type alias Model =
    { authStatus : AuthenticationStatus
    , loginScreen : LoginScreen.Model
    }


initialModel : Model
initialModel =
    { authStatus = LoggedOut
    , loginScreen = LoginScreen.initialModel
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ loginScreen } as model) =
    case msg of
        LoginMsg subMsg ->
            let
                ( loginScreen, cmd, info ) =
                    LoginScreen.update subMsg model.loginScreen
            in
                let
                    authStatus =
                        case info of
                            Just loginInfo ->
                                LoggedIn loginInfo

                            Nothing ->
                                LoggedOut
                in
                    ( { model
                        | loginScreen = loginScreen
                        , authStatus = authStatus
                      }
                    , Cmd.map LoginMsg cmd
                    )

        UserMsg subMsg ->
            case subMsg of
                UserHome.Logout ->
                    ( { model
                        | authStatus = LoggedOut
                        , loginScreen = LoginScreen.initialModel
                      }
                    , Cmd.none
                    )


view : Model -> Html.Html Msg
view model =
    case model.authStatus of
        LoggedIn info ->
            Html.App.map UserMsg (UserHome.view info)

        LoggedOut ->
            Html.App.map LoginMsg (LoginScreen.view model.loginScreen)


main : Program Never
main =
    Html.App.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
