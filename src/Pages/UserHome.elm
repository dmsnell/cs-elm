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
  { user : User
  , username : String
  }


initialModel : Model
initialModel =
  { user = emptyUser
  , username = ""
  }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Logout ->
      ( model, Cmd.none )

    ChangeUsername ->
      let oldUser = model.user

          newUser =
            { oldUser | username = model.username }

      in
        ( { model | user = newUser }, Cmd.none )

    UpdateUsernameField value ->
      ( { model | username = value }, Cmd.none )


view : Model -> Html.Html Msg
view model =
  div []
      [ div [] [ text ("Hi " ++ model.user.username) ]
      , div []
            [ label [ for "username" ] [ text "Username:" ]
            , input [ name "username", value model.username, onInput UpdateUsernameField ] []
            ]
      , div [] [ button [ onClick ChangeUsername ] [ text "Renew" ] ]
      , div [] [ button [ onClick Logout ] [ text "Logout" ] ]
      ]
