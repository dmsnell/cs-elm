module Models.AuthenticationResponse exposing (..)

import Models.User exposing (..)

type alias AuthenticationResponse =
  { apiKey : String
  , user : User
  }


emptyResponse : AuthenticationResponse
emptyResponse =
  { apiKey = ""
  , user = emptyUser
  }
