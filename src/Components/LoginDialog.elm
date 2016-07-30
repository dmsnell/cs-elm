module Components.LoginDialog exposing (..)

import Html exposing (div, button, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


type Msg
  = SubmitLogin
  | UpdateEmail String
  | UpdatePassword String


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

    UpdateEmail email ->
      ( { model | email = email }, Cmd.none )

    UpdatePassword password ->
      ( { model | password = password }, Cmd.none )


view : Model -> Html.Html Msg
view model =
  div []
      [ text "Login"
      , div []
            [ label [ for "email" ] [ text "Email" ]
            , input [ name "email", value model.email, onInput UpdateEmail ] []
            ]
      , div []
            [ label [ for "password"] [ text "Password" ]
            , input [ type' "password", name "password", value model.password, onInput UpdatePassword ] []
            ]
      , button [ onClick SubmitLogin ] [ text "Login" ]
      ]
