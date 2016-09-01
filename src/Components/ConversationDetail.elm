module Components.ConversationDetail exposing (..)

import Html exposing (div, ul, li, p, text)
import Models.Conversation exposing (Conversation)
import Components.MessageDetail as MessageDetail


view : Conversation -> Html.Html msg
view { title, messages } =
    div []
        [ div [] [ text title ]
        , div [] <| List.map MessageDetail.view messages
        ]
