module Components.LoginDialog exposing (..)

import Html exposing (div, button, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type Msg
  = SubmitLogin


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


view : Model -> Html.Html Msg
view model =
  div []
      [ text "Login"
      , div []
            [ label [ for "email" ] [ text "Email" ]
            , input [ name "email", value model.email ] []
            ]
      , div []
            [ label [ for "password"] [ text "Password" ]
            , input [ type' "password", name "password", value model.password ] []
            ]
      , button [ onClick SubmitLogin ] [ text "Login" ]
      ]
