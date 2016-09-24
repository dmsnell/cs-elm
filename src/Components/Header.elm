module Components.Header exposing (..)

import Html exposing (button, div, text)
import Html.Events exposing (onClick)
import LoggedIn.Messages exposing (..)
import Models.User exposing (User)


view : Maybe User -> Html.Html Msg
view user =
    let
        profileButton =
            case user of
                Just { name } ->
                    button [ onClick (SelectSection SectionProfile) ] [ text name ]

                Nothing ->
                    text ""
    in
        div []
            [ text "Community Share"
            , profileButton
            , button [ onClick Logout ] [ text "Logout" ]
            ]
