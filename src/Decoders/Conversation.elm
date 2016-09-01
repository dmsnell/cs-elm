module Decoders.Conversation exposing (..)

import Date exposing (Date)
import Date.Extra exposing (fromParts)
import Json.Decode exposing (andThen, bool, int, maybe, string, float, succeed, Decoder)
import Json.Decode.Pipeline exposing (custom, decode, hardcoded, optional, required)
import String as String
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


decodeUser : Decoder User.User
decodeUser =
    decode User.User
        |> required "id" int
        |> required "name" string
        |> required "picture_url" ((maybe string) `andThen` decodeAvatar)
        |> required "active" bool
        |> required "bio" string
        |> required "zipcode" (string `andThen` decodeZipcode)
        |> required "website" (maybe string)
        |> required "is_administrator" (bool `andThen` decodeSiteRole)
        |> required "is_educator" (bool `andThen` decodeMemberRole)


decodeAvatar : Maybe String -> Decoder String
decodeAvatar url =
    succeed <|
        Maybe.withDefault
            User.defaultAvatarUrl
            url


decodeZipcode : String -> Decoder (Maybe Int)
decodeZipcode z =
    succeed <|
        Result.toMaybe (String.toInt z)


decodeSiteRole : Bool -> Decoder User.SiteRole
decodeSiteRole role =
    succeed <|
        case role of
            True ->
                User.Administrator

            False ->
                User.Guest


decodeMemberRole : Bool -> Decoder User.MemberRole
decodeMemberRole role =
    succeed <|
        case role of
            True ->
                User.Educator

            False ->
                User.Partner
