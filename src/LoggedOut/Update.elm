module LoggedOut.Update exposing (..)

import Task
import LoggedOut.Model exposing (..)
import LoggedOut.Messages exposing (..)
import Tasks.AuthenticateUser exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg, Maybe LoginInfo )
update msg model =
    case msg of
        SubmitLogin ->
            let
                task =
                    requestLoginToken model.credentials
                        |> Task.perform LoginResponse LoginResponse
            in
                ( model, task, Nothing )

        UpdateLogin field value ->
            let
                updated =
                    updateLoginField model.credentials field value
            in
                ( { model | credentials = updated }, Cmd.none, Nothing )

        LoginResponse response ->
            case response of
                Ok info ->
                    ( { model | loginError = Nothing }, Cmd.none, Just info )

                Err error ->
                    ( { model | loginError = Just error }, Cmd.none, Nothing )


updateLoginField : Credentials -> LoginField -> String -> Credentials
updateLoginField credentials field value =
    case field of
        LoginEmail ->
            { credentials | email = value }

        LoginPassword ->
            { credentials | password = value }
