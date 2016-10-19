module Components.SectionMessage exposing (..)

import Dict exposing (Dict)
import Html exposing (button, div, text)
import Html.Events exposing (onClick)
import Components.ConversationDetail as Detail
import Components.ConversationSummary as Summary
import LoggedIn.Messages exposing (..)
import Models.Conversation exposing (Conversation, conversationUsers, emptyConversation)
import Models.User exposing (User)


view : Dict Int Conversation -> Maybe Int -> Dict Int String -> Dict Int User -> User -> Html.Html Msg
view conversations selectedConversation newMessages users me =
    if Dict.size conversations == 0 then
        div []
            [ text "Loading…" ]
    else
        case selectedConversation of
            Just id ->
                let
                    conversation =
                        Dict.get id conversations
                            |> Maybe.withDefault emptyConversation

                    ( left, right ) =
                        conversationUsers me.id users conversation

                    newMessage =
                        Dict.get conversation.id newMessages
                            |> Maybe.withDefault ""
                in
                    div []
                        [ button [ onClick UnselectConversation ] [ text "Back" ]
                        , Detail.view conversation newMessage me left right
                        ]

            Nothing ->
                div []
                    [ conversations
                        |> Dict.values
                        |> List.map (Summary.view me users)
                        |> div []
                    ]
