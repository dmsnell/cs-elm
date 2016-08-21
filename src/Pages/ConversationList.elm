module Pages.ConversationList exposing (..)

import Html exposing (button, div, ul, li, text)
import Html.Events exposing (onClick)
import Html.App
import Components.ConversationDetail as Detail
import Components.ConversationSummary as Summary
import Decoders.Conversation exposing (Conversation, emptyConversation)


type Msg
    = SummaryMsg Summary.Msg
    | UnselectMessage


type alias Model =
    { selectedConversation : Maybe Int
    }


initialModel : Model
initialModel =
    { selectedConversation = Nothing
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SummaryMsg subMsg ->
            case subMsg of
                Summary.SelectConversation id ->
                    ( { model | selectedConversation = Just id }, Cmd.none )

                _ ->
                    ( model, Cmd.none )

        UnselectMessage ->
            ( { model | selectedConversation = Nothing }, Cmd.none )


view : Model -> List Conversation -> Html.Html Msg
view model conversations =
    case model.selectedConversation of
        Just id ->
            let
                conversation =
                    Maybe.withDefault emptyConversation <| List.head conversations
            in
                div []
                    [ button [ onClick UnselectMessage ] [ text "Back" ]
                    , Detail.view conversation
                    ]

        Nothing ->
            div []
                [ div [] <|
                    List.map
                        (Html.App.map SummaryMsg)
                        (List.map Summary.view conversations)
                ]
