module Models.User exposing (User, emptyUser)

type alias Username = String

type alias User =
  { id : Int
  , username : Username
  }

emptyUser : User
emptyUser =
  { id = 0
  , username = ""
  }
