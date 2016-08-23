module App exposing (main)

import Html exposing (div, text)
import Html.App
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
    , userHome : UserHome.Model
    }


initialModel : Model
initialModel =
    { authStatus = LoggedOut
    , loginScreen = LoginScreen.initialModel
    , userHome = UserHome.initialModel
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

                    ( userModel, userCmd ) =
                        case info of
                            Just loginInfo ->
                                UserHome.update UserHome.FetchMessages model.userHome loginInfo

                            Nothing ->
                                ( model.userHome, Cmd.none )
                in
                    ( { model
                        | loginScreen = loginScreen
                        , authStatus = authStatus
                      }
                    , Cmd.batch [ Cmd.map LoginMsg cmd, Cmd.map UserMsg userCmd ]
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

                _ ->
                    let
                        loginInfo =
                            case model.authStatus of
                                LoggedIn info ->
                                    info

                                LoggedOut ->
                                    { apiKey = "", email = "" }

                        ( userHome, cmd ) =
                            UserHome.update subMsg model.userHome loginInfo
                    in
                        ( { model | userHome = userHome }, Cmd.map UserMsg cmd )


view : Model -> Html.Html Msg
view model =
    case model.authStatus of
        LoggedIn info ->
            Html.App.map UserMsg (UserHome.view model.userHome info)

        LoggedOut ->
            Html.App.map LoginMsg (LoginScreen.view model.loginScreen)


main : Program Never
main =
    Html.App.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
