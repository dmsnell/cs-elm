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


users : Dict Int User -> Conversation -> ( User, User )
users userDict conversation =
    let
        left =
            userDict
                |> Dict.get conversation.leftUserId
                |> Maybe.withDefault emptyUser

        right =
            userDict
                |> Dict.get conversation.rightUserId
                |> Maybe.withDefault emptyUser
    in
        ( left, right )
