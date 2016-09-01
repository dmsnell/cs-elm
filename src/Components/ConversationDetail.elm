module Components.ConversationDetail exposing (..)

import Html exposing (div, ul, li, p, text)
import Html.Attributes exposing (..)
import Components.MessageDetail as MessageDetail
import Models.Conversation exposing (Conversation)
import Models.User exposing (User)


view : Conversation -> Int -> User -> User -> Html.Html msg
view { title, messages } myUserId left right =
    div []
        [ div
            [ style
                [ ( "font-size", "16px" )
                , ( "font-weight", "bold" )
                , ( "margin", "1em 0" )
                ]
            ]
            [ text title ]
        , div [] <| List.map (MessageDetail.view myUserId left right) messages
        ]
