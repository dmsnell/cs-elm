module Components.ConversationDetail exposing (..)

import Html exposing (div, ul, li, p, text)
import Decoders.Conversation exposing (Conversation, Message)
import Components.MessageDetail as MessageDetail
import Models.User exposing (User, emptyUser)


messageUser : Message -> User -> User -> User
messageUser { senderId } left right =
    if senderId == left.id then
        left
    else if senderId == right.id then
        right
    else
        emptyUser


view : Conversation -> Html.Html msg
view { title, messages, userA, userB } =
    div []
        [ div [] [ text title ]
        , div [] <|
            List.map
                (\m -> MessageDetail.view m <| messageUser m userA userB)
                messages
        ]
