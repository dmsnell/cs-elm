module Pages.UserHome exposing (..)

import Cmd.Extra exposing (message)
import Dict exposing (Dict)
import Html exposing (button, div, h1, input, label, p, text)
import Html.App
import Components.Header as Header
import Components.SideBar as SideBar
import Task as Task
import Tasks.AuthenticateUser exposing (LoginInfo)
import Tasks.FetchConversations exposing (fetchConversations)
import Tasks.FetchMe exposing (fetchMe)
import Models.Conversation exposing (Conversation)
import Models.User exposing (User, emptyUser)
import Pages.ConversationList as Messages


type Msg
    = Logout
    | HeaderMsg Header.Msg
    | SideBarMsg SideBar.Msg
    | ConversationMsg Messages.Msg
    | FetchResponse (Result String ( Dict Int Conversation, Dict Int User ))
    | FetchMeFailed String
    | FetchMeLoaded (Result String User)


type alias Model =
    { activeSection : SideBar.Section
    , conversations : Dict Int Conversation
    , messagePane : Messages.Model
    , users : Dict.Dict Int User
    , myUserId : Int
    }


initialModel : Model
initialModel =
    { activeSection = SideBar.Messages
    , conversations = Dict.empty
    , messagePane = Messages.initialModel
    , users = Dict.empty
    , myUserId = 0
    }


fetchMessages : LoginInfo -> Cmd Msg
fetchMessages loginInfo =
    Task.perform FetchResponse FetchResponse <| fetchConversations loginInfo


fetchMyUser : LoginInfo -> Cmd Msg
fetchMyUser loginInfo =
    Task.perform FetchMeFailed FetchMeLoaded <| fetchMe loginInfo


mergeUsers : Dict Int User -> List User -> Dict Int User
mergeUsers existing new =
    Dict.fromList <|
        List.concat
            [ Dict.toList existing
            , List.map (\u -> ( u.id, u )) new
            ]


update : Msg -> Model -> LoginInfo -> ( Model, Cmd Msg )
update msg model loginInfo =
    case msg of
        Logout ->
            ( model, Cmd.none )

        HeaderMsg subMsg ->
            ( model, message Logout )

        FetchResponse response ->
            case response of
                Ok ( conversations, users ) ->
                    ( { model
                        | conversations = Dict.union model.conversations conversations
                        , users = Dict.union model.users users
                      }
                    , Cmd.none
                    )

                Err error ->
                    let
                        e =
                            Debug.log "Conversations" e
                    in
                        ( model, Cmd.none )

        FetchMeFailed error ->
            ( model, Cmd.none )

        FetchMeLoaded result ->
            case result of
                Ok me ->
                    ( { model
                        | myUserId = me.id
                        , users = Dict.insert me.id me model.users
                      }
                    , Cmd.none
                    )

                Err error ->
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
        , div []
            [ h1 [] [ text <| toString model.activeSection ]
            , case model.activeSection of
                SideBar.Messages ->
                    Html.App.map ConversationMsg <| Messages.view model.messagePane model.conversations model.myUserId model.users

                _ ->
                    div [] [ text "No content yet" ]
            ]
        ]
