module Pages.LoginScreen exposing (..)

import Html exposing (div, text)
import Html.App
import Task exposing (Task)
import Tasks.AuthenticateUser exposing (requestLoginToken)
import Components.LoginDialog as Dialog
import Models.User exposing (User)


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


update : Msg -> Model -> ( Model, Maybe (Task String (Maybe User)) )
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
