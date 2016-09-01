module Pages.ConversationList exposing (..)

import Dict exposing (Dict)
import Html exposing (button, div, ul, li, text)
import Html.Events exposing (onClick)
import Html.App
import Components.ConversationDetail as Detail
import Components.ConversationSummary as Summary
import Models.Conversation as Conversation
import Models.Conversation exposing (Conversation, emptyConversation)
import Models.User exposing (User, emptyUser)


type Msg
    = SummaryMsg Summary.Msg
    | DetailMsg Detail.Msg
    | UnselectMessage


type alias Model =
    { selectedConversation : Maybe Int
    , detail : Detail.Model
    }


initialModel : Model
initialModel =
    { selectedConversation = Nothing
    , detail = Detail.emptyModel
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SummaryMsg subMsg ->
            case subMsg of
                Summary.SelectConversation id ->
                    ( { model | selectedConversation = Just id }, Cmd.none )

        DetailMsg subMsg ->
            let
                ( detail, cmd ) =
                    Detail.update subMsg model.detail
            in
                ( { model | detail = detail }, cmd )

        UnselectMessage ->
            ( { model | selectedConversation = Nothing }, Cmd.none )


view : Model -> Dict Int Conversation -> Int -> Dict Int User -> Html.Html Msg
view model conversations myUserId users =
    if Dict.size conversations == 0 then
        div []
            [ text "Loading…" ]
    else
        case model.selectedConversation of
            Just id ->
                let
                    conversation =
                        Maybe.withDefault emptyConversation <| Dict.get id conversations

                    ( left, right ) =
                        Conversation.users myUserId users conversation
                in
                    div []
                        [ button [ onClick UnselectMessage ] [ text "Back" ]
                        , Html.App.map DetailMsg <| Detail.view conversation myUserId left right
                        ]

            Nothing ->
                div []
                    [ div [] <|
                        List.map
                            (Html.App.map SummaryMsg)
                            (conversations
                                |> Dict.values
                                |> List.map (Summary.view myUserId users)
                            )
                    ]
