module Encoders.NewMessage exposing (..)

import Date exposing (Date)
import Date.Extra exposing (fromParts, toUtcIsoString)
import Json.Encode exposing (Value, encode, int, object, string)


type alias NewMessage =
    { content : String
    , conversationId : Int
    , dateCreated : Date
    , senderId : Int
    }


encodeNewMessage : Int -> Int -> String -> String
encodeNewMessage conversationId senderUserId content =
    { content = content
    , conversationId = conversationId
    , dateCreated = (fromParts 2000 Date.Jan 1 0 0 0 0)
    , senderId = senderUserId
    }
        |> newMessage
        |> encode 0


newMessage : NewMessage -> Value
newMessage { content, conversationId, dateCreated, senderId } =
    object
        [ ( "content", string content )
        , ( "conversation_id", int conversationId )
        , ( "date_created", string <| "2016-09-12T02:00:34.765Z" )
        , ( "sender_user_id", int senderId )
        ]
