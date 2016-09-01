module Components.ConversationSummary exposing (..)

import Html exposing (div, img, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Models.Conversation exposing (Conversation)


type Msg
    = SelectConversation Int


view : Conversation -> Html.Html Msg
view { id, title, messages } =
    div [ onClick <| SelectConversation id ]
        [ div [] [ text title ]
        ]
