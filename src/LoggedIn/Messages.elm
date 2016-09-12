module LoggedIn.Messages exposing (..)


type Msg
    = Logout
    | SelectConversation Int
    | SelectSection SiteSection
    | SubmitMessage
    | UnselectConversation
    | UpdateMessage String


type SiteSection
    = SectionSearch
    | SectionMessages
    | SectionShares
    | SectionMatches
