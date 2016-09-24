module LoggedIn.Messages exposing (..)

import Date exposing (Date)
import Models.Message exposing (Message)


type Msg
    = Logout
    | GetDateAndThen (Date -> Msg)
    | SelectConversation Int
    | SelectSection SiteSection
    | SubmitMessage Int Date
    | SubmitMessageFailed Int String String
    | SubmitMessageLoaded (Result String Message)
    | UnselectConversation
    | UpdateMessage Int String


type SiteSection
    = SectionMatches
    | SectionMessages
    | SectionProfile
    | SectionSearch
    | SectionShares
