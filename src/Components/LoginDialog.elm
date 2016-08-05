module Components.LoginDialog exposing (..)

import Html exposing (div, button, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

type Field
  = Email
  | Password

type Msg
  = SubmitLogin
  | Update Field String


type alias Model
  = { email : String
    , password : String
    }


initialModel : Model
initialModel
  = { email = ""
    , password = ""
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SubmitLogin ->
      ( model, Cmd.none )

    Update field value ->
      let next =
        case field of
          Email ->
            { model | email = value }

          Password ->
            { model | password = value }
      in
        ( next, Cmd.none )


view : Model -> Html.Html Msg
view model =
  div []
      [ text "Login"
      , div []
            [ label [ for "email" ] [ text "Email" ]
            , input [ name "email", value model.email, onInput (Update Email) ] []
            ]
      , div []
            [ label [ for "password"] [ text "Password" ]
            , input [ type' "password", name "password", value model.password, onInput (Update Password) ] []
            ]
      , button [ onClick SubmitLogin ] [ text "Login" ]
      ]
