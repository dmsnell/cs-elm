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
    , avatarUrl : String
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
    , avatarUrl = defaultAvatarUrl
    , isActive = False
    , biography = ""
    , zipcode = Nothing
    , websiteUrl = Nothing
    , siteRole = Guest
    , memberRole = Lurker
    }


defaultAvatarUrl : String
defaultAvatarUrl =
    "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mm"
