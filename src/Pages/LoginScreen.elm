module Pages.LoginScreen exposing (..)

import Html exposing (div, text)
import Html.App
import Http
import Task exposing (Task)
import Json.Decode

import Components.LoginDialog as Dialog
import Decoders.AuthenticationResponse exposing (decodeAuthenitcationResponse)
import Models.AuthenticationResponse exposing (AuthenticationResponse, emptyResponse)


type Msg
  = FormMsg Dialog.Msg
  | FetchSuccess Http.Response
  | FetchError Http.RawError


type alias Model
  = { loginForm : Dialog.Model
    , apiKey : Maybe String
    , error : Maybe String
    }


initialModel : Model
initialModel
  = { loginForm = Dialog.initialModel
    , apiKey = Nothing
    , error = Nothing
    }


requestToken : Dialog.Model -> Task Http.RawError Http.Response
requestToken { email, password } =
  Http.send Http.defaultSettings
    { verb = "GET"
    , headers = [ ("Authorization", "Basic:" ++ email ++ ":" ++ password)
                ]
    , url = "http://localhost:5000/api/requestapikey"
    , body = Http.empty
    }


fetchUserToken : Dialog.Model -> Cmd Msg
fetchUserToken model =
  Task.perform FetchError FetchSuccess (requestToken model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    FormMsg formMsg ->
      if formMsg == Dialog.SubmitLogin

      then
        ( model, fetchUserToken model.loginForm )

      else
        let
          ( loginForm, cmd ) = Dialog.update formMsg model.loginForm

        in
          ( { model | loginForm = loginForm }, Cmd.map FormMsg cmd )

    FetchSuccess response ->
      let json = case response.value of
            Http.Text s -> s
            _ -> "{apiKey: '', user: {}}"

          authResponse =
            Json.Decode.decodeString decodeAuthenitcationResponse json

          (apiKey, error) =
            case authResponse of
              Ok response ->
                (Just response.apiKey, Nothing)

              Err e ->
                (Nothing, Just e)

      in
          ( { model
                | apiKey = apiKey
                , error = error
                }, Cmd.none )

    FetchError error ->
        case error of
            Http.RawTimeout ->
                ( { model | error = Just "Timeout contacting server" }, Cmd.none )

            Http.RawNetworkError ->
                ( { model | error = Just "Network error" }, Cmd.none )


view : Model -> Html.Html Msg
view model =
  let error =
    case model.error of
      Nothing -> ""
      Just e -> e

  in
    div []
        [ renderForm model
        , div [] [ text error ]
        ]


renderForm : Model -> Html.Html Msg
renderForm model =
  Html.App.map FormMsg (Dialog.view model.loginForm)
