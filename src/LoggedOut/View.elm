module LoggedOut.View exposing (..)

import Html exposing (Html, div, button, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import LoggedOut.Messages exposing (..)
import LoggedOut.Model exposing (..)


view : Model -> Html Msg
view { credentials, loginError } =
    div []
        [ text "Login"
        , div []
            [ label [ for "email" ] [ text "Email" ]
            , input [ name "email", value credentials.email, onInput (UpdateLogin LoginEmail) ] []
            ]
        , div []
            [ label [ for "password" ] [ text "Password" ]
            , input [ type' "password", name "password", value credentials.password, onInput (UpdateLogin LoginPassword) ] []
            ]
        , button [ onClick SubmitLogin ] [ text "Login" ]
        , text (Maybe.withDefault "" loginError)
        ]
