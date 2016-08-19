module Pages.UserHome exposing (..)

import Html exposing (button, div, input, label, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Models.User exposing (User, emptyUser)
import Tasks.AuthenticateUser exposing (LoginInfo)


type Msg
    = Logout


type alias Model =
    {}


initialModel : Model
initialModel =
    {}


update : Msg -> Cmd Msg
update msg =
    case msg of
        Logout ->
            (Cmd.none)


view : LoginInfo -> Html.Html Msg
view info =
    div []
        [ div [] [ text ("Hi " ++ info.email) ]
        , div [] [ button [ onClick Logout ] [ text "Logout" ] ]
        ]
