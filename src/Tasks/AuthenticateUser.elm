module Tasks.AuthenticateUser exposing (..)

import Http
import Json.Decode
import Task exposing (Task)
import Decoders.AuthenticationResponse exposing (decodeAuthenticationResponse)


type alias AuthenticationTask =
    Task (Result String String) (Result String String)


type alias LoginCredentials =
    { email : String
    , password : String
    }


requestLoginToken : LoginCredentials -> AuthenticationTask
requestLoginToken { email, password } =
    { verb = "GET"
    , headers = [ ( "Authorization", "Basic:" ++ email ++ ":" ++ password ) ]
    , url = "https://app.communityshare.us/api/requestapikey"
    , body = Http.empty
    }
        |> Http.send Http.defaultSettings
        |> Task.map handleResponse
        |> Task.mapError errorText


decodeResponse : String -> Result String String
decodeResponse json =
    let
        decoded =
            Json.Decode.decodeString decodeAuthenticationResponse json
    in
        case decoded of
            Ok data ->
                Ok <| data.apiKey

            Err error ->
                Err <| error


handleResponse : Http.Response -> Result String String
handleResponse { status, statusText, value } =
    case status of
        200 ->
            case value of
                Http.Text t ->
                    decodeResponse t

                _ ->
                    Err statusText

        401 ->
            Err "Invalid login combination. Please try again."

        _ ->
            Err statusText


errorText : Http.RawError -> Result String String
errorText error =
    case error of
        Http.RawTimeout ->
            Err "Timeout contacting server"

        Http.RawNetworkError ->
            Err "Network error"
