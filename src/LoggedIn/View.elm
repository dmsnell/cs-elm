module LoggedIn.View exposing (..)

import Dict
import Html exposing (div, h1, text)
import Components.Header as Header
import Components.SectionMessage as SectionMessage
import Components.SectionProfile as SectionProfile
import Components.SideBar as SideBar
import LoggedIn.Model exposing (..)
import LoggedIn.Messages exposing (..)
import Tasks.AuthenticateUser exposing (LoginInfo)


view : Model -> LoginInfo -> Html.Html Msg
view model info =
    div []
        [ Header.view (Dict.get model.myUserId model.users)
        , SideBar.view
        , div []
            [ h1 [] [ text <| toString model.activeSection ]
            , case model.activeSection of
                SectionMessages ->
                    SectionMessage.view model.conversations model.selectedConversation model.newMessages model.users model.myUserId

                SectionProfile ->
                    SectionProfile.view (Dict.get model.myUserId model.users)

                _ ->
                    div [] [ text "No content yet" ]
            ]
        ]
