module Pages.LoginScreen exposing (..)

import Html exposing (div, text)

import Messages exposing (Msg)
import Components.LoginDialog as Dialog


view : Html.Html Msg
view =
  div []
      [ Dialog.view ]
