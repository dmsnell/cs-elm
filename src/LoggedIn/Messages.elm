module LoggedIn.Messages exposing (..)

import Models.Message exposing (Message)


type Msg
    = Logout
    | SelectConversation Int
    | SelectSection SiteSection
    | SubmitMessage Int
    | SubmitMessageFailed String
    | SubmitMessageLoaded (Result String Message)
    | UnselectConversation
    | UpdateMessage Int String


type SiteSection
    = SectionSearch
    | SectionMessages
    | SectionShares
    | SectionMatches
