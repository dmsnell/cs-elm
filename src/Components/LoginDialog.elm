module Components.LoginDialog exposing (..)

import Html exposing (div, button, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Messages exposing (..)

view : Html.Html Msg
view =
  div []
      [ text "Login"
      , div []
            [ label [ for "email" ] [ text "Email" ]
            , input [ name "email" ] []
            ]
      , div []
            [ label [ for "password"] [ text "Password" ]
            , input [ type' "password", name "password" ] []
            ]
      , button [ onClick SubmitLogin ] [ text "Login" ]
      ]
