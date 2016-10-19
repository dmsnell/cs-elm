module LoggedIn.UpdateMessages exposing (..)

import Date exposing (Date)
import Dict
import Task
import Encoders.NewMessage exposing (encodeNewMessage)
import LoggedIn.Messages exposing (..)
import LoggedIn.Model exposing (..)
import Models.Message exposing (Message)
import Tasks.AuthenticateUser exposing (LoginInfo)
import Tasks.Messages exposing (sendNewMessage)


updateSubmitMessage : Model -> LoginInfo -> Int -> Date -> ( Model, Cmd Msg )
updateSubmitMessage model info conversationId date =
    let
        message =
            Dict.get conversationId model.newMessages
    in
        case message of
            Just content ->
                let
                    newMessage =
                        encodeNewMessage conversationId info.me.id content date
                in
                    ( { model
                        | newMessages = Dict.insert conversationId "Sending…" model.newMessages
                      }
                    , sendNewMessage info newMessage
                        |> Task.perform (SubmitMessageFailed conversationId content) SubmitMessageLoaded
                    )

            Nothing ->
                ( model, Cmd.none )


updateSubmitMessageLoaded : Model -> Result String Message -> ( Model, Cmd Msg )
updateSubmitMessageLoaded model result =
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


updateSubmitMessageFailed : Model -> Int -> String -> String -> ( Model, Cmd Msg )
updateSubmitMessageFailed model conversationId previousContent error =
    ( { model
        | newMessages = Dict.insert conversationId previousContent model.newMessages
      }
    , Cmd.none
    )
