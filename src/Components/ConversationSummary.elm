module Components.ConversationSummary exposing (..)

import Html exposing (div, img, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Decoders.Conversation exposing (Conversation)


type Msg
    = SelectConversation Int


view : Conversation -> Html.Html Msg
view { id, title, messages, userB } =
    div [ onClick <| SelectConversation id ]
        [ img [ src userB.avatarUrl ] []
        , div []
            [ div [] [ text userB.name ]
            , p [] [ text userB.biography ]
            ]
        ]
