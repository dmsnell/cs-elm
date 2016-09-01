module Pages.Messages exposing (..)

import Html exposing (div, h1, text)
import Decoders.Conversation exposing (Conversation)
import Pages.ConversationList as Messages


view : Messages.Model -> List Conversation -> Html.Html Messages.Msg
view messages conversations =
    div []
        [ Messages.view messages conversations
        ]
