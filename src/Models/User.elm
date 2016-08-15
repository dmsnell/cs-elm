module Models.User exposing (User, emptyUser)


type alias User =
    { id : Int
    , email : String
    }


emptyUser : User
emptyUser =
    { id = 0
    , email = ""
    }
