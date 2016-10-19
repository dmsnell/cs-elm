module LoggedIn.Model exposing (..)

import Dict exposing (Dict)
import LoggedIn.Messages exposing (..)
import Models.Conversation exposing (Conversation)
import Models.User exposing (User)


type alias Model =
    { activeSection : SiteSection
    , conversations : Dict Int Conversation
    , newMessages : Dict Int String
    , users : Dict Int User
    , selectedConversation : Maybe Int
    }


emptyModel : Model
emptyModel =
    { activeSection = SectionMessages
    , conversations = Dict.empty
    , newMessages = Dict.empty
    , users = Dict.empty
    , selectedConversation = Nothing
    }
