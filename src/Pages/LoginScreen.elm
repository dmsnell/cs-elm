module Pages.LoginScreen exposing (..)

import Html exposing (div, text)
import Html.App
import Http
import Debug
import Task exposing (Task)
import Json.Decode as Decode

import Components.LoginDialog as Dialog


type Msg
  = FormMsg Dialog.Msg
  | FetchSuccess Http.Response
  | FetchError Http.RawError


type alias Model
  = { loginForm : Dialog.Model
    , response : String
    , error : Maybe String
    }


initialModel : Model
initialModel
  = { loginForm = Dialog.initialModel
    , response = ""
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
            _ -> "{apiKey: ''}"

          ( apiKey, error ) =
            case Decode.decodeString (Decode.at [ "apiKey" ] Decode.string) json of
              Ok v -> ( v, Nothing )
              Err e -> ( "", Just "Invalid email and password combination" )

      in
          ( { model | response = apiKey, error = error }, Debug.log apiKey Cmd.none )

    FetchError error ->
        case error of
            Http.RawTimeout ->
                ( { model | error = Just "Timeout contacting server" }, Cmd.none )

            Http.RawNetworkError ->
                ( { model | error = Just "Network error" }, Cmd.none )


view : Model -> Html.Html Msg
view model =
  div []
      [ renderForm model
      , case model.error of
          Nothing -> text ""
          Just s -> div [] [ text s ]
      ]


renderForm : Model -> Html.Html Msg
renderForm model =
  Html.App.map FormMsg (Dialog.view model.loginForm)
