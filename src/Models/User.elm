module Models.User exposing (..)


type SiteRole
    = Guest
    | Administrator


type MemberRole
    = Educator
    | Partner
    | Lurker


type alias User =
    { id : Int
    , name : String
    , avatarUrl : Maybe String
    , isActive : Bool
    , biography : String
    , zipcode : Maybe Int
    , websiteUrl : Maybe String
    , siteRole : SiteRole
    , memberRole : MemberRole
    }


emptyUser : User
emptyUser =
    { id = 0
    , name = ""
    , avatarUrl = Nothing
    , isActive = False
    , biography = ""
    , zipcode = Nothing
    , websiteUrl = Nothing
    , siteRole = Guest
    , memberRole = Lurker
    }
