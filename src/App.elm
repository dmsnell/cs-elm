module App exposing (main)

import Dict exposing (Dict)
import Html exposing (div, text)
import Html.App
import Task exposing (Task)
import LoggedIn.Messages as LIMsg
import LoggedIn.Model as LIModel
import LoggedIn.Update as LIUpdate
import LoggedIn.View as LIView
import LoggedOut.Messages as LOMsg
import LoggedOut.Model as LOModel
import LoggedOut.Update as LOUpdate
import LoggedOut.View as LOView
import Models.Conversation exposing (Conversation)
import Models.User exposing (User, emptyUser)
import Tasks.AuthenticateUser exposing (LoginInfo)
import Tasks.FetchConversations exposing (fetchConversations)


type Msg
    = LoggedOutMsg LOMsg.Msg
    | LoggedInMsg LIMsg.Msg
    | FetchConversations (Result String ( Dict Int Conversation, Dict Int User ))


type AuthenticationStatus
    = LoggedOut
    | LoggedIn LoginInfo


type alias Model =
    { authStatus : AuthenticationStatus
    , loggedOut : LOModel.Model
    , loggedIn : LIModel.Model
    }


initialModel : Model
initialModel =
    { authStatus = LoggedOut
    , loggedOut = LOModel.emptyModel
    , loggedIn = LIModel.emptyModel
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchConversations response ->
            case response of
                Ok ( conversations, users ) ->
                    ( { model
                        | loggedIn = LIUpdate.mergeConversations model.loggedIn conversations users
                      }
                    , Cmd.none
                    )

                Err _ ->
                    ( model, Cmd.none )

        LoggedOutMsg subMsg ->
            let
                ( loggedOut, cmd, info ) =
                    LOUpdate.update subMsg model.loggedOut
            in
                let
                    authStatus =
                        info
                            |> Maybe.map LoggedIn
                            |> Maybe.withDefault LoggedOut

                    fetchMyConversations =
                        info
                            |> Maybe.map fetchConversations
                            |> Maybe.map (Task.perform FetchConversations FetchConversations)
                            |> Maybe.withDefault Cmd.none

                    loggedIn =
                        case info of
                            Just { me } ->
                                LIUpdate.addUser model.loggedIn me

                            Nothing ->
                                model.loggedIn
                in
                    ( { model
                        | loggedOut = loggedOut
                        , loggedIn = loggedIn
                        , authStatus = authStatus
                      }
                    , Cmd.batch
                        [ Cmd.map LoggedOutMsg cmd
                        , fetchMyConversations
                        ]
                    )

        LoggedInMsg subMsg ->
            case subMsg of
                LIMsg.Logout ->
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
                                    { apiKey = "", me = emptyUser }

                        ( loggedIn, cmd ) =
                            LIUpdate.update subMsg model.loggedIn loginInfo
                    in
                        ( { model | loggedIn = loggedIn }, Cmd.map LoggedInMsg cmd )


view : Model -> Html.Html Msg
view model =
    case model.authStatus of
        LoggedIn info ->
            Html.App.map LoggedInMsg (LIView.view model.loggedIn info)

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
