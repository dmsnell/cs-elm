module App exposing (main)

import Html exposing (div, text)
import Html.App as Html

import Messages exposing (..)
import Models.User exposing (User)

import Pages.LoginScreen as LoginScreen
import Pages.UserHome as UserHome

type alias Model =
  { user : Maybe User
  }


initialModel : Model
initialModel =
  { user = Nothing
  }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    SubmitLogin ->
      { model | user = Just (User 14 "Bob") } ! []

    Logout ->
      { model | user = Nothing } ! []

    _ ->
      model ! []


view : Model -> Html.Html Msg
view model =
  case model.user of
    Just user -> UserHome.view user
    Nothing -> LoginScreen.view


main =
  Html.program
    { init = ( initialModel, Cmd.none )
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
