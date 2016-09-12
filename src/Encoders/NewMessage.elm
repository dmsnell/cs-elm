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


encodeNewMessage : Int -> Int -> String -> Date -> String
encodeNewMessage conversationId senderUserId content date =
    { content = content
    , conversationId = conversationId
    , dateCreated = date
    , senderId = senderUserId
    }
        |> newMessage
        |> encode 0


newMessage : NewMessage -> Value
newMessage { content, conversationId, dateCreated, senderId } =
    object
        [ ( "content", string content )
        , ( "conversation_id", int conversationId )
        , ( "date_created", string <| toUtcIsoString dateCreated )
        , ( "sender_user_id", int senderId )
        ]
