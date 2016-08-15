module Pages.LoginScreen exposing (..)

import Html exposing (div, text)
import Html.App
import Tasks.AuthenticateUser exposing (AuthenticationTask, requestLoginToken)
import Components.LoginDialog as Dialog


type Msg
    = FormMsg Dialog.Msg


type ChildMsg
    = SubmitLogin


type alias Model =
    { loginForm : Dialog.Model
    , error : Maybe String
    }


initialModel : Model
initialModel =
    { loginForm = Dialog.initialModel
    , error = Nothing
    }


update : Msg -> Model -> ( Model, Maybe AuthenticationTask )
update msg model =
    case msg of
        FormMsg formMsg ->
            let
                ( loginForm, action ) =
                    Dialog.update SubmitLogin formMsg model.loginForm
            in
                case action of
                    Just SubmitLogin ->
                        ( model, Just (requestLoginToken model.loginForm) )

                    _ ->
                        ( { model | loginForm = loginForm }, Nothing )


view : Model -> Html.Html Msg
view model =
    let
        error =
            case model.error of
                Nothing ->
                    ""

                Just e ->
                    e
    in
        div []
            [ renderForm model
            , div [] [ text error ]
            ]


renderForm : Model -> Html.Html Msg
renderForm model =
    Html.App.map FormMsg (Dialog.view model.loginForm)
