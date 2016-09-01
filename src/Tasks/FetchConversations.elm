module Tasks.FetchConversations exposing (..)

import Http
import Json.Decode
import Task exposing (Task)
import Decoders.Conversation exposing (ApiConversation, ApiMessage, decodeConversations)
import Models.Conversation exposing (Conversation)
import Models.Message exposing (Message)
import Models.User exposing (User)
import Tasks.AuthenticateUser exposing (LoginInfo)


type alias ConversationTask =
    Task (Result String ( List Conversation, List User )) (Result String ( List Conversation, List User ))


fetchConversations : LoginInfo -> ConversationTask
fetchConversations loginInfo =
    { verb = "GET"
    , headers = [ ( "Authorization", "Basic:api:" ++ loginInfo.apiKey ) ]
    , url = Http.url "https://app.communityshare.us/api/conversation" [ ( "user_id", "976" ) ]
    , body = Http.empty
    }
        |> Http.send Http.defaultSettings
        |> Task.map handleResponse
        |> Task.mapError errorText


apiToConversation : ApiConversation -> Conversation
apiToConversation { id, title, dateCreated, messages } =
    { id = id
    , title = title
    , dateCreated = dateCreated
    , messages = List.map apiToMessage messages
    }


apiToMessage : ApiMessage -> Message
apiToMessage { id, conversationId, content, dateCreated, senderId, hasBeenViewed } =
    { id = id
    , conversationId = conversationId
    , content = content
    , dateCreated = dateCreated
    , senderId = senderId
    , hasBeenViewed = hasBeenViewed
    }


decodeResponse : String -> Result String ( List Conversation, List User )
decodeResponse json =
    let
        decoded =
            Json.Decode.decodeString decodeConversations json
    in
        case decoded of
            Ok data ->
                Ok <| ( List.map apiToConversation data, [] )

            Err error ->
                Err <| error


handleResponse : Http.Response -> Result String ( List Conversation, List User )
handleResponse { status, statusText, value } =
    case status of
        200 ->
            case value of
                Http.Text t ->
                    decodeResponse t

                _ ->
                    Err "Unrecognized response from server."

        401 ->
            Err "Invalid login combination. Please try again."

        _ ->
            Err <| "Unrecognized error: " ++ statusText


errorText : Http.RawError -> Result String ( List Conversation, List User )
errorText error =
    case error of
        Http.RawTimeout ->
            Err "Timeout contacting server"

        Http.RawNetworkError ->
            Err "Network error"
