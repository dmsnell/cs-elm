module Pages.UserHome exposing (..)

import Cmd.Extra exposing (message)
import Html exposing (button, div, h1, input, label, p, text)
import Html.App
import Html.Events exposing (onClick)
import Components.Header as Header
import Components.SideBar as SideBar
import Task as Task
import Tasks.AuthenticateUser exposing (LoginInfo)
import Tasks.FetchConversations exposing (fetchConversations)
import Decoders.Conversation exposing (Conversation)
import Pages.ConversationList as Messages


type Msg
    = Logout
    | HeaderMsg Header.Msg
    | SideBarMsg SideBar.Msg
    | ConversationMsg Messages.Msg
    | FetchMessages
    | FetchResponse (Result String (List Conversation))


type alias Model =
    { activeSection : SideBar.Section
    , conversations : List Conversation
    , messagePane : Messages.Model
    }


initialModel : Model
initialModel =
    { activeSection = SideBar.Messages
    , conversations = []
    , messagePane = Messages.initialModel
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
                    ( { model | conversations = conversations }, Cmd.none )

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

        ConversationMsg subMsg ->
            let
                ( messagePane, cmd ) =
                    Messages.update subMsg model.messagePane
            in
                ( { model | messagePane = messagePane }, Cmd.none )


view : Model -> LoginInfo -> Html.Html Msg
view model info =
    div []
        [ Html.App.map HeaderMsg Header.view
        , Html.App.map SideBarMsg SideBar.view
        , button [ onClick FetchMessages ] [ text "Fetch Messages" ]
        , div []
            [ h1 [] [ text <| toString model.activeSection ]
            , Html.App.map ConversationMsg <| Messages.view model.messagePane model.conversations
            ]
        ]
