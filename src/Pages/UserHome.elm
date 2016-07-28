module Pages.UserHome exposing (..)

import Html exposing (button, div, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Messages exposing (..)
import Models.User exposing (User)

view : User -> Html.Html Msg
view user =
  div []
      [ text "Logged in!"
      , button [ onClick Logout ] [ text "Logout" ]
      ]
