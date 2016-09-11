module LoggedOut.Messages exposing (..)

import Tasks.AuthenticateUser exposing (LoginInfo)


type Msg
    = SubmitLogin
    | UpdateLogin LoginField String
    | LoginResponse (Result String LoginInfo)


type LoginField
    = LoginEmail
    | LoginPassword
