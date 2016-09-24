module Tasks.FetchMe exposing (..)

import Http
import Json.Decode
import Task exposing (Task)
import Decoders.User exposing (decodeUser)
import Models.User exposing (User, emptyUser)
import Tasks.AuthenticateUser exposing (LoginInfo)
import Tasks.Helpers exposing (requestUrl)


type alias MeFetcher =
    Task String (Result String User)


fetchMe : LoginInfo -> MeFetcher
fetchMe { email, apiKey } =
    { verb = "GET"
    , headers = [ ( "Authorization", "Basic:api:" ++ apiKey ) ]
    , url = requestUrl ("/api/userbyemail/" ++ email)
    , body = Http.empty
    }
        |> Http.send Http.defaultSettings
        |> Task.map handleResponse
        |> Task.mapError
            (\error ->
                case error of
                    Http.RawTimeout ->
                        "Timeout contacting server"

                    Http.RawNetworkError ->
                        "Network error"
            )


handleResponse : Http.Response -> Result String User
handleResponse { status, statusText, value } =
    case status of
        200 ->
            case value of
                Http.Text json ->
                    decodeResponse json

                _ ->
                    Err "Unrecognized response from server"

        _ ->
            Err <| "Uncrecognized error: " ++ statusText


decodeResponse : String -> Result String User
decodeResponse json =
    case Json.Decode.decodeString (Json.Decode.at [ "data" ] decodeUser) json of
        Ok data ->
            Ok data

        Err error ->
            Err error
