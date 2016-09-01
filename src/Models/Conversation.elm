module Models.Conversation exposing (..)

import Date exposing (Date)
import Date.Extra exposing (fromParts)
import Models.Message exposing (Message)


type alias Conversation =
    { id : Int
    , title : String
    , dateCreated : Date
    , messages : List Message
    }


emptyConversation : Conversation
emptyConversation =
    { id = 0
    , title = ""
    , dateCreated = fromParts 2000 Date.Jan 1 0 0 0 0
    , messages = []
    }
