module Components.ConversationSummary exposing (..)

import Dict exposing (Dict)
import Html exposing (div, img, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import LoggedIn.Messages exposing (..)
import Models.Conversation as Conversation
import Models.Conversation exposing (Conversation, conversationUsers)
import Models.User exposing (User, emptyUser)


view : User -> Dict Int User -> Conversation -> Html.Html Msg
view me users ({ id, title, messages } as conversation) =
    let
        ( left, right ) =
            conversationUsers me.id users conversation

        involvesMe =
            List.member me.id [ left.id, right.id ]

        leftName =
            if involvesMe then
                "you"
            else
                left.name
    in
        div [ onClick <| SelectConversation id ]
            [ div [] [ text <| "Between " ++ leftName ++ " and " ++ right.name ]
            , img [ src right.avatarUrl, width 32 ] []
            , div [ style [ ( "marginBottom", "2em" ) ] ] [ text title ]
            ]
