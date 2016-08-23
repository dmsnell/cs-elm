module Components.ConversationDetail exposing (..)

import Html exposing (div, ul, li, p, text)
import Decoders.Conversation exposing (Conversation, Message)
import Components.MessageDetail as MessageDetail


view : Conversation -> Html.Html msg
view { title, messages, userA, userB } =
    div []
        [ div [] [ text title ]
        , div [] <|
            List.map
                MessageDetail.view
                messages
        ]
