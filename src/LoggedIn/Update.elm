module LoggedIn.Update exposing (..)

import Basics.Extra exposing (never)
import Date exposing (now)
import Dict exposing (Dict)
import Task
import LoggedIn.Messages exposing (..)
import LoggedIn.Model exposing (..)
import LoggedIn.UpdateMessages exposing (..)
import Models.Conversation exposing (Conversation)
import Models.User exposing (User)
import Tasks.AuthenticateUser exposing (LoginInfo)


update : Msg -> Model -> LoginInfo -> ( Model, Cmd Msg )
update msg model info =
    case msg of
        GetDateAndThen action ->
            ( model, Task.perform never action now )

        Logout ->
            ( model, Cmd.none )

        SelectConversation id ->
            ( { model | selectedConversation = Just id }, Cmd.none )

        SelectSection section ->
            ( { model | activeSection = section }, Cmd.none )

        UnselectConversation ->
            ( { model | selectedConversation = Nothing }, Cmd.none )

        UpdateMessage conversationId text ->
            ( { model
                | newMessages = Dict.insert conversationId text model.newMessages
              }
            , Cmd.none
            )

        SubmitMessage conversationId date ->
            updateSubmitMessage model info conversationId date

        SubmitMessageFailed conversationId previousContent error ->
            updateSubmitMessageFailed model conversationId previousContent error

        SubmitMessageLoaded result ->
            updateSubmitMessageLoaded model result


mergeConversations : Model -> Dict Int Conversation -> Dict Int User -> Model
mergeConversations model conversations users =
    { model
        | conversations = Dict.union model.conversations conversations
        , users = Dict.union model.users users
    }


addUser : Model -> User -> Model
addUser model user =
    { model | users = Dict.insert user.id user model.users }
