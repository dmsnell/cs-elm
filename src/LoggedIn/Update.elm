module LoggedIn.Update exposing (..)

import Basics.Extra exposing (never)
import Date exposing (now)
import Dict exposing (Dict)
import Task
import Encoders.NewMessage exposing (encodeNewMessage)
import LoggedIn.Messages exposing (..)
import LoggedIn.Model exposing (..)
import Models.Conversation exposing (Conversation)
import Models.User exposing (User)
import Tasks.AuthenticateUser exposing (LoginInfo)
import Tasks.Messages exposing (sendNewMessage)


update : Msg -> Model -> LoginInfo -> ( Model, Cmd Msg )
update msg model info =
    case msg of
        GetDateAndThen action ->
            ( model, Task.perform never action now )

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
            let
                message =
                    Dict.get conversationId model.newMessages
            in
                case message of
                    Just content ->
                        let
                            newMessage =
                                encodeNewMessage conversationId model.myUserId content date
                                    |> Debug.log "New Message"

                            task =
                                Task.perform SubmitMessageFailed SubmitMessageLoaded (sendNewMessage info newMessage)
                        in
                            ( model, task )

                    Nothing ->
                        ( model, Cmd.none )

        SubmitMessageFailed error ->
            ( model, Cmd.none )

        SubmitMessageLoaded result ->
            case result of
                Ok message ->
                    let
                        conversation =
                            Dict.get message.conversationId model.conversations
                                |> Maybe.map (\c -> ({ c | messages = Dict.insert message.id message c.messages }))

                        conversations =
                            case conversation of
                                Just c ->
                                    Dict.insert c.id c model.conversations

                                Nothing ->
                                    model.conversations
                    in
                        ( { model
                            | newMessages = Dict.remove message.conversationId model.newMessages
                            , conversations = conversations
                          }
                        , Cmd.none
                        )

                Err error ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


setMe : Model -> User -> Model
setMe model user =
    { model
        | myUserId = user.id
        , users = Dict.insert user.id user model.users
    }


mergeConversations : Model -> Dict Int Conversation -> Dict Int User -> Model
mergeConversations model conversations users =
    { model
        | conversations = Dict.union model.conversations conversations
        , users = Dict.union model.users users
    }
