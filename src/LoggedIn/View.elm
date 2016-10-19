module LoggedIn.View exposing (..)

import Html exposing (div, h1, text)
import Components.Header as Header
import Components.SectionMessage as SectionMessage
import Components.SideBar as SideBar
import LoggedIn.Model exposing (..)
import LoggedIn.Messages exposing (..)
import Tasks.AuthenticateUser exposing (LoginInfo)


view : Model -> LoginInfo -> Html.Html Msg
view model info =
    div []
        [ Header.view
        , SideBar.view
        , div []
            [ h1 [] [ text <| toString model.activeSection ]
            , case model.activeSection of
                SectionMessages ->
                    SectionMessage.view model.conversations model.selectedConversation model.newMessages model.users info.me

                _ ->
                    div [] [ text "No content yet" ]
            ]
        ]
