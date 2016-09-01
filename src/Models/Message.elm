module Models.Message exposing (..)

import Date exposing (Date)
import Date.Extra exposing (fromParts)


type alias Message =
    { id : Int
    , conversationId : Int
    , content : String
    , dateCreated : Date
    , senderId : Int
    , hasBeenViewed : Bool
    }


emptyMessage : Message
emptyMessage =
    { id = 0
    , conversationId = 0
    , content = ""
    , dateCreated = fromParts 2000 Date.Jan 1 0 0 0 0
    , senderId = 0
    , hasBeenViewed = False
    }
