module Pages.UserHome exposing (..)

import Cmd.Extra exposing (message)
import Html exposing (button, div, input, label, text)
import Html.App
import Components.Header as Header
import Components.SideBar as SideBar
import Tasks.AuthenticateUser exposing (LoginInfo)


type Msg
    = Logout
    | HeaderMsg Header.Msg
    | SideBarMsg SideBar.Msg


type alias Model =
    { activeSection : SideBar.Section
    }


initialModel : Model
initialModel =
    { activeSection = SideBar.Messages
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Logout ->
            ( model, Cmd.none )

        HeaderMsg subMsg ->
            ( model, message Logout )

        SideBarMsg subMsg ->
            case subMsg of
                SideBar.Select section ->
                    ( { model | activeSection = section }, Cmd.none )

                _ ->
                    ( model, Cmd.none )


view : Model -> LoginInfo -> Html.Html Msg
view model info =
    div []
        [ Html.App.map HeaderMsg Header.view
        , Html.App.map SideBarMsg SideBar.view
        , div []
            [ text <| toString model.activeSection ]
        ]
