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
conversationUsers myUserId users { leftUserId, rightUserId } =
    {-
       Each conversation should show one's own user as the left user
       if indeed the user is part of the conversation. This function
       will make that determination and return the appropriate results,
       replacing the user ids from the conversation data with real users
    -}
    let
        sorted =
            [ leftUserId, rightUserId ]
                |> List.sortBy
                    (\id ->
                        if id == myUserId then
                            0
                        else
                            1
                    )
                |> List.map (flip Dict.get users)
                |> List.map (Maybe.withDefault emptyUser)
    in
        case sorted of
            [ left, right ] ->
                ( left, right )

            _ ->
                ( emptyUser, emptyUser )
