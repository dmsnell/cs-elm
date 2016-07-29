module Pages.UserHome exposing (..)

import Html exposing (button, div, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Models.User exposing (User)

type Msg
  = Logout


type alias Model =
  Maybe User


initialModel : Model
initialModel =
  Nothing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Logout ->
      ( Nothing, Cmd.none )


view : Model -> Html.Html Msg
view model =
  div []
      [ text "Logged in!"
      , button [ onClick Logout ] [ text "Logout" ]
      ]
