module Components.Header exposing (..)

import Html exposing (button, div, text)
import Html.Events exposing (onClick)
import LoggedIn.Messages exposing (..)


view : Html.Html Msg
view =
    div []
        [ text "Community Share"
        , button [ onClick Logout ] [ text "Logout" ]
        ]
