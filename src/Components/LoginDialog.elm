module Components.LoginDialog exposing (..)

import Html exposing (div, button, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


type Msg
    = SubmitLogin
    | UpdateEmail String
    | UpdatePassword String


type alias Model =
    { email : String
    , password : String
    }


initialModel : Model
initialModel =
    { email = ""
    , password = ""
    }


update : Cmd msg -> Msg -> Model -> ( Model, Cmd msg )
update onSubmit msg model =
    case msg of
        SubmitLogin ->
            ( model, onSubmit )

        UpdateEmail value ->
            ( { model | email = value }, Cmd.none )

        UpdatePassword value ->
            ( { model | password = value }, Cmd.none )


view : Model -> Html.Html Msg
view model =
    div []
        [ text "Login"
        , div []
            [ label [ for "email" ] [ text "Email" ]
            , input [ name "email", value model.email, onInput UpdateEmail ] []
            ]
        , div []
            [ label [ for "password" ] [ text "Password" ]
            , input [ type' "password", name "password", value model.password, onInput UpdatePassword ] []
            ]
        , button [ onClick SubmitLogin ] [ text "Login" ]
        ]
