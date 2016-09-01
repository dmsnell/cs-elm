module Components.ConversationDetail exposing (..)

import Date
import Html exposing (button, div, ul, li, p, text, textarea)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Components.MessageDetail as MessageDetail
import Models.Conversation exposing (Conversation)
import Models.User exposing (User)


type Msg
    = UpdateMessage String


type alias Model =
    { newMessage : String
    }


emptyModel : Model
emptyModel =
    { newMessage = ""
    }


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        UpdateMessage text ->
            ( { model | newMessage = text }, Cmd.none )


newMessageForm : String -> Html.Html Msg
newMessageForm newMessage =
    div
        [ style
            [ ( "margin", "auto" )
            , ( "width", "90%" )
            ]
        ]
        [ textarea
            [ placeholder "Add to the conversation…"
            , style
                [ ( "width", "100%" )
                , ( "min-height", "100px" )
                , ( "border-radius", "8px" )
                , ( "padding", "8px" )
                , ( "margin", "0" )
                , ( "box-sizing", "border-box" )
                , ( "font-size", "14px" )
                ]
            , onInput UpdateMessage
            ]
            [ text newMessage ]
        , div [ style [ ( "text-align", "right" ) ] ]
            [ button [] [ text "Send Message" ]
            ]
        ]


view : Model -> Conversation -> Int -> User -> User -> Html.Html Msg
view model { title, messages } myUserId left right =
    div []
        [ div
            [ style
                [ ( "font-size", "16px" )
                , ( "font-weight", "bold" )
                , ( "margin", "1em 0" )
                ]
            ]
            [ text title ]
        , newMessageForm model.newMessage
        , div []
            (messages
                |> List.sortBy (.dateCreated >> Date.toTime)
                |> List.reverse
                |> List.map (MessageDetail.view myUserId left right)
            )
        ]
