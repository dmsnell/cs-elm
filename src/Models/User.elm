module Models.User exposing (User)

type alias Username = String

type alias User =
  { id : Int
  , username : Username
  }
