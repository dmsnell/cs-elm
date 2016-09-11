module App exposing (main)

import Html exposing (div, text)
import Html.App
import LoggedOut.Messages as LOMsg
import LoggedOut.Model as LOModel
import LoggedOut.Update as LOUpdate
import LoggedOut.View as LOView
import Pages.UserHome as UserHome
import Tasks.AuthenticateUser exposing (LoginInfo)


type Msg
    = LoggedOutMsg LOMsg.Msg
    | UserMsg UserHome.Msg


type AuthenticationStatus
    = LoggedOut
    | LoggedIn LoginInfo


type alias Model =
    { authStatus : AuthenticationStatus
    , loggedOut : LOModel.Model
    , userHome : UserHome.Model
    }


initialModel : Model
initialModel =
    { authStatus = LoggedOut
    , loggedOut = LOModel.emptyModel
    , userHome = UserHome.initialModel
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoggedOutMsg subMsg ->
            let
                ( loggedOut, cmd, info ) =
                    LOUpdate.update subMsg model.loggedOut
            in
                let
                    authStatus =
                        case info of
                            Just loginInfo ->
                                LoggedIn loginInfo

                            Nothing ->
                                LoggedOut

                    ( fetchMyUser, fetchMessages ) =
                        case info of
                            Just loginInfo ->
                                ( UserHome.fetchMessages loginInfo
                                , UserHome.fetchMyUser loginInfo
                                )

                            Nothing ->
                                ( Cmd.none, Cmd.none )
                in
                    ( { model
                        | loggedOut = loggedOut
                        , authStatus = authStatus
                      }
                    , Cmd.batch
                        [ Cmd.map LoggedOutMsg cmd
                        , Cmd.map UserMsg fetchMessages
                        , Cmd.map UserMsg fetchMyUser
                        ]
                    )

        UserMsg subMsg ->
            case subMsg of
                UserHome.Logout ->
                    ( { model
                        | authStatus = LoggedOut
                        , loggedOut = LOModel.emptyModel
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
            Html.App.map LoggedOutMsg (LOView.view model.loggedOut)


main : Program Never
main =
    Html.App.program
        { init = ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
