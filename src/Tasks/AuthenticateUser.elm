module Tasks.AuthenticateUser exposing (..)

import Http
import Json.Decode
import Task exposing (Task)
import Decoders.AuthenticationResponse exposing (decodeAuthenticationResponse)
import Models.User exposing (User)


type alias AuthenticationTask =
    Task (Result String LoginInfo) (Result String LoginInfo)


type alias LoginCredentials =
    { email : String
    , password : String
    }


type alias LoginInfo =
    { me : User
    , apiKey : String
    }


requestLoginToken : LoginCredentials -> AuthenticationTask
requestLoginToken { email, password } =
    { verb = "GET"
    , headers = [ ( "Authorization", "Basic:" ++ email ++ ":" ++ password ) ]
    , url = "https://app.communityshare.us/api/requestapikey"
    , body = Http.empty
    }
        |> Http.send Http.defaultSettings
        |> Task.map (handleResponse email)
        |> Task.mapError errorText


decodeResponse : String -> String -> Result String LoginInfo
decodeResponse email json =
    let
        decoded =
            Json.Decode.decodeString decodeAuthenticationResponse json
    in
        case decoded of
            Ok data ->
                Ok <| LoginInfo data.me data.apiKey

            Err error ->
                Err <| error


handleResponse : String -> Http.Response -> Result String LoginInfo
handleResponse email { status, statusText, value } =
    case status of
        200 ->
            case value of
                Http.Text t ->
                    decodeResponse email t

                _ ->
                    Err "Unrecognized response from server."

        401 ->
            Err "Invalid login combination. Please try again."

        _ ->
            Err <| "Unrecognized error: " ++ statusText


errorText : Http.RawError -> Result String LoginInfo
errorText error =
    case error of
        Http.RawTimeout ->
            Err "Timeout contacting server"

        Http.RawNetworkError ->
            Err "Network error"
