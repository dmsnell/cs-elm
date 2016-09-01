module Decoders.Conversation exposing (..)

import Date exposing (Date)
import Date.Extra exposing (fromParts)
import Json.Decode exposing (andThen, bool, int, maybe, string, float, succeed, Decoder)
import Json.Decode.Pipeline exposing (custom, decode, hardcoded, optional, required)
import Decoders.User exposing (decodeUser)
import Models.User as User


type alias ApiConversation =
    { id : Int
    , title : String
    , dateCreated : Date
    , messages : List ApiMessage
    , userA : User.User
    , userB : User.User
    }


emptyConversation : ApiConversation
emptyConversation =
    { id = 0
    , title = ""
    , dateCreated = fromParts 2000 Date.Jan 1 0 0 0 0
    , messages = []
    , userA = User.emptyUser
    , userB = User.emptyUser
    }


type alias ApiMessage =
    { content : String
    , id : Int
    , conversationId : Int
    , senderId : Int
    , hasBeenViewed : Bool
    , dateCreated : Date
    }


decodeConversations : Decoder (List ApiConversation)
decodeConversations =
    Json.Decode.at [ "data" ] <|
        Json.Decode.list decodeConversation


decodeConversation : Decoder ApiConversation
decodeConversation =
    decode ApiConversation
        |> required "id" int
        |> required "title" string
        |> required "date_created" (string `andThen` decodeDate)
        |> required "messages" (Json.Decode.list decodeMessage)
        |> required "userA" decodeUser
        |> required "userB" decodeUser


decodeDate : String -> Decoder Date
decodeDate t =
    succeed <|
        (Result.withDefault (fromParts 2000 Date.Jan 1 0 0 0 0) (Date.fromString t))


decodeMessage : Decoder ApiMessage
decodeMessage =
    decode ApiMessage
        |> required "content" string
        |> required "id" int
        |> required "conversation_id" int
        |> required "sender_user_id" int
        |> required "viewed" bool
        |> required "date_created" (string `andThen` decodeDate)
