module Tasks.AuthenticateUser exposing (..)

import Http
import Json.Decode
import Task exposing (Task)

import Decoders.AuthenticationResponse exposing (decodeAuthenticationResponse)
import Models.User exposing (User)

type alias LoginCredentials =
    { email: String
    , password: String
    }

requestLoginToken : LoginCredentials -> Task String (Maybe User)
requestLoginToken { email, password } =
    { verb = "GET"
    , headers = [ ("Authorization", "Basic:" ++ email ++ ":" ++ password) ]
    , url = "http://localhost:5000/api/requestapikey"
    , body = Http.empty
    }
    |> Http.send Http.defaultSettings
    |> Task.map (responseText >> decodeResponse)
    |> Task.mapError errorText


decodeResponse : String -> Maybe User
decodeResponse json =
    let decoded = Json.Decode.decodeString decodeAuthenticationResponse json

    in case decoded of
        Ok _ ->
            Just (User 42 "test@example.com")
        
        _ ->
            Nothing



responseText : Http.Response -> String
responseText response =
    case response.value of
        Http.Text t ->
            t 
        
        _ ->
            ""


errorText : Http.RawError -> String
errorText error =
    case error of
        Http.RawTimeout ->
            "Timeout contacting server"
        
        Http.RawNetworkError ->
            "Network error"