module Pages.UserHome exposing (..)

import Html exposing (button, div, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

import Models.User exposing (User)

type Msg
  = Logout
  | ChangeUsername
  | UpdateUsernameField String


type alias Model =
  { user : Maybe User
  , username : String
  }


initialModel : Model
initialModel =
  { user = Nothing
  , username = ""
  }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Logout ->
      ( { model | user = Nothing }, Cmd.none )

    ChangeUsername ->
      let newUser =
        case model.user of
          Nothing ->
            Nothing

          Just user ->
            Just { user | username = model.username }

      in
        ( { model | user = newUser }, Cmd.none )

    UpdateUsernameField value ->
      ( { model | username = value }, Cmd.none )


view : Model -> Html.Html Msg
view model =
  case model.user of
    Nothing ->
      div []
          [ text "Loading user…" ]

    Just user ->
      div []
          [ div [] [ text ("Hi " ++ user.username) ]
          , div []
                [ label [ for "username" ] [ text "Username:" ]
                , input [ name "username", value model.username, onInput UpdateUsernameField ] []
                ]
          , div [] [ button [ onClick ChangeUsername ] [ text "Renew" ] ]
          , div [] [ button [ onClick Logout ] [ text "Logout" ] ]
          ]
