module LoggedOut.Model exposing (..)


type alias Model =
    { credentials : Credentials
    , loginError : Maybe String
    }


type alias Credentials =
    { email : String
    , password : String
    }


emptyModel : Model
emptyModel =
    { credentials = emptyCredentials
    , loginError = Nothing
    }


emptyCredentials : Credentials
emptyCredentials =
    { email = ""
    , password = ""
    }
