module Pages.UserHome exposing (..)

import Cmd.Extra exposing (message)
import Html exposing (button, div, input, label, text)
import Html.App
import Html.Events exposing (onClick)
import Components.Header as Header
import Components.SideBar as SideBar
import Task as Task
import Tasks.AuthenticateUser exposing (LoginInfo)
import Tasks.FetchConversations exposing (fetchConversations)
import Decoders.Conversation exposing (Conversation)


type Msg
    = Logout
    | HeaderMsg Header.Msg
    | SideBarMsg SideBar.Msg
    | FetchMessages
    | FetchResponse (Result String Conversation)


type alias Model =
    { activeSection : SideBar.Section
    , conversations : List Conversation
    }


initialModel : Model
initialModel =
    { activeSection = SideBar.Messages
    , conversations = []
    }


update : Msg -> Model -> LoginInfo -> ( Model, Cmd Msg )
update msg model loginInfo =
    case msg of
        Logout ->
            ( model, Cmd.none )

        HeaderMsg subMsg ->
            ( model, message Logout )

        FetchMessages ->
            ( model, Task.perform FetchResponse FetchResponse <| fetchConversations loginInfo )

        FetchResponse response ->
            case response of
                Ok conversations ->
                    let
                        c =
                            Debug.log "Conversations" conversations
                    in
                        ( { model | conversations = [ conversations ] }, Cmd.none )

                Err error ->
                    let
                        e =
                            Debug.log "Conversations" e
                    in
                        ( model, Cmd.none )

        SideBarMsg subMsg ->
            case subMsg of
                SideBar.Select section ->
                    ( { model | activeSection = section }, Cmd.none )

                _ ->
                    ( model, Cmd.none )


conversationView : Conversation -> Html.Html Msg
conversationView conversation =
    div [] <|
        List.map (\m -> text m.title) <|
            Debug.log "conversationView" conversation


view : Model -> LoginInfo -> Html.Html Msg
view model info =
    div []
        [ Html.App.map HeaderMsg Header.view
        , Html.App.map SideBarMsg SideBar.view
        , div []
            [ text <| toString model.activeSection ]
        , button [ onClick FetchMessages ] [ text "Fetch Messages" ]
        , div []
            (List.map conversationView model.conversations)
        ]
