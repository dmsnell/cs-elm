module Components.ConversationSummary exposing (..)

import Dict exposing (Dict)
import Html exposing (div, img, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Models.Conversation exposing (Conversation)
import Models.User exposing (User, emptyUser)


type Msg
    = SelectConversation Int


view : Dict Int User -> Conversation -> Html.Html Msg
view users { id, title, messages, leftUserId, rightUserId } =
    let
        left =
            users
                |> Dict.get leftUserId
                |> Maybe.withDefault emptyUser

        right =
            users
                |> Dict.get rightUserId
                |> Maybe.withDefault emptyUser
    in
        div [ onClick <| SelectConversation id ]
            [ div [] [ text <| "Between " ++ left.name ++ " and " ++ right.name ]
            , img [ src left.avatarUrl, width 32 ] []
            , div [ style [ ( "marginBottom", "2em" ) ] ] [ text title ]
            ]
