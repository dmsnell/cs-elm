module Components.ConversationDetail exposing (..)

import Date
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
        , div []
            (messages
                |> List.sortBy (.dateCreated >> Date.toTime)
                |> List.reverse
                |> List.map (MessageDetail.view myUserId left right)
            )
        ]
