module Pages.UserHome exposing (..)

import Html exposing (button, div, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

import Models.User exposing (User, emptyUser)

type Msg
  = Logout
  | ChangeUsername
  | UpdateUsernameField String


type alias Model =
  { email : String
  }


initialModel : Model
initialModel =
  { email = ""
  }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Logout ->
      ( model, Cmd.none )

    ChangeUsername ->
      ( model, Cmd.none )

    UpdateUsernameField value ->
      ( { model | email = value }, Cmd.none )


view : Model -> User -> Html.Html Msg
view model user =
  div []
      [ div [] [ text ("Hi " ++ user.email) ]
      , div []
            [ label [ for "username" ] [ text "Username:" ]
            , input [ name "username", value model.email, onInput UpdateUsernameField ] []
            ]
      , div [] [ button [ onClick ChangeUsername ] [ text "Renew" ] ]
      , div [] [ button [ onClick Logout ] [ text "Logout" ] ]
      ]
