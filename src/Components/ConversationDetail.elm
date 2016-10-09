module Components.ConversationDetail exposing (..)

import Date
import Dict
import Html exposing (button, div, ul, li, p, text, textarea)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Components.MessageDetail as MessageDetail
import LoggedIn.Messages exposing (..)
import Models.Conversation exposing (Conversation)
import Models.User exposing (User)


newMessageForm : Int -> String -> Html.Html Msg
newMessageForm conversationId newMessage =
    div
        [ style
            [ ( "margin", "auto" )
            , ( "width", "90%" )
            ]
        ]
        [ textarea
            [ placeholder "Add to the conversation…"
            , value newMessage
            , style
                [ ( "width", "100%" )
                , ( "min-height", "100px" )
                , ( "border-radius", "8px" )
                , ( "padding", "8px" )
                , ( "margin", "0" )
                , ( "box-sizing", "border-box" )
                , ( "font-size", "14px" )
                ]
            , onInput (UpdateMessage conversationId)
            ]
            []
        , div [ style [ ( "text-align", "right" ) ] ]
            [ button
                [ onClick (GetDateAndThen (SubmitMessage conversationId)) ]
                [ text "Send Message" ]
            ]
        ]


view : Conversation -> String -> Int -> User -> User -> Html.Html Msg
view { id, title, messages } newMessage myUserId left right =
    div []
        [ div
            [ style
                [ ( "font-size", "16px" )
                , ( "font-weight", "bold" )
                , ( "margin", "1em 0" )
                ]
            ]
            [ text title ]
        , newMessageForm id newMessage
        , div []
            (messages
                |> Dict.values
                |> List.sortBy (.dateCreated >> Date.toTime)
                |> List.reverse
                |> List.map (MessageDetail.view myUserId left right)
            )
        ]
