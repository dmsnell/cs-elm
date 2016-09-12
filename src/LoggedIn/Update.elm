module LoggedIn.Update exposing (..)

import Dict exposing (Dict)
import LoggedIn.Messages exposing (..)
import LoggedIn.Model exposing (..)
import Models.Conversation exposing (Conversation)
import Models.User exposing (User)
import Tasks.AuthenticateUser exposing (LoginInfo)


update : Msg -> Model -> LoginInfo -> ( Model, Cmd Msg )
update msg model info =
    case msg of
        SelectConversation id ->
            ( { model | selectedConversation = Just id }, Cmd.none )

        SelectSection section ->
            ( { model | activeSection = section }, Cmd.none )

        UnselectConversation ->
            ( { model | selectedConversation = Nothing }, Cmd.none )

        _ ->
            ( model, Cmd.none )


setMe : Model -> User -> Model
setMe model user =
    { model
        | myUserId = user.id
        , users = Dict.insert user.id user model.users
    }


mergeConversations : Model -> Dict Int Conversation -> Dict Int User -> Model
mergeConversations model conversations users =
    { model
        | conversations = Dict.union model.conversations conversations
        , users = Dict.union model.users users
    }
