module Tasks.Messages exposing (..)

import Json.Decode
import Http
import Task exposing (Task)
import Decoders.Conversation exposing (decodeMessage)
import Models.Message exposing (Message)
import Tasks.AuthenticateUser exposing (LoginInfo)
import Tasks.FetchConversations exposing (apiToMessage)


sendNewMessage : LoginInfo -> String -> Task String (Result String Message)
sendNewMessage { email, apiKey } message =
    { verb = "POST"
    , headers =
        [ ( "Authorization", "Basic:api:" ++ apiKey )
        , ( "Content-Type", "application/json;charset=UTF-8" )
        ]
    , url = "https://app.communityshare.us/api/message"
    , body = Http.string message
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


decodeResponse : String -> Result String Message
decodeResponse json =
    let
        decoded =
            decodeMessage
                |> Json.Decode.at [ "data" ]
                |> (flip Json.Decode.decodeString) json
    in
        case decoded of
            Ok data ->
                Ok <| apiToMessage data

            Err error ->
                Err <| error


handleResponse : Http.Response -> Result String Message
handleResponse { status, statusText, value } =
    case status of
        200 ->
            case value of
                Http.Text json ->
                    decodeResponse json

                _ ->
                    Err "Unrecognized data format in response from server"

        _ ->
            Err "Failure!"
