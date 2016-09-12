module Components.SectionMessage exposing (..)

import Dict exposing (Dict)
import Html exposing (button, div, text)
import Html.Events exposing (onClick)
import Components.ConversationDetail as Detail
import Components.ConversationSummary as Summary
import LoggedIn.Messages exposing (..)
import Models.Conversation exposing (Conversation, conversationUsers, emptyConversation)
import Models.User exposing (User)


view : Dict Int Conversation -> Maybe Int -> Dict Int User -> Int -> Html.Html Msg
view conversations selectedConversation users myUserId =
    if Dict.size conversations == 0 then
        div []
            [ text "Loading…" ]
    else
        case selectedConversation of
            Just id ->
                let
                    conversation =
                        Maybe.withDefault emptyConversation <| Dict.get id conversations

                    ( left, right ) =
                        conversationUsers myUserId users conversation
                in
                    div []
                        [ button [ onClick UnselectConversation ] [ text "Back" ]
                        , Detail.view conversation myUserId left right
                        ]

            Nothing ->
                div []
                    [ conversations
                        |> Dict.values
                        |> List.map (Summary.view myUserId users)
                        |> div []
                    ]
