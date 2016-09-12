module Models.Conversation exposing (..)

import Dict exposing (Dict)
import Date exposing (Date)
import Date.Extra exposing (fromParts)
import Models.Message exposing (Message)
import Models.User exposing (User, emptyUser)


type alias Conversation =
    { id : Int
    , title : String
    , dateCreated : Date
    , messages : List Message
    , leftUserId : Int
    , rightUserId : Int
    }


emptyConversation : Conversation
emptyConversation =
    { id = 0
    , title = ""
    , dateCreated = fromParts 2000 Date.Jan 1 0 0 0 0
    , messages = []
    , leftUserId = 0
    , rightUserId = 0
    }


conversationUsers : Int -> Dict Int User -> Conversation -> ( User, User )
conversationUsers myUserId userDict { leftUserId, rightUserId } =
    let
        involvesMe =
            List.member myUserId [ leftUserId, rightUserId ]

        leftId =
            if involvesMe then
                myUserId
            else
                leftUserId

        rightId =
            if involvesMe then
                (if myUserId == leftUserId then
                    rightUserId
                 else
                    leftUserId
                )
            else
                rightUserId

        left =
            userDict
                |> Dict.get leftId
                |> Maybe.withDefault emptyUser

        right =
            userDict
                |> Dict.get rightId
                |> Maybe.withDefault emptyUser
    in
        ( left, right )
