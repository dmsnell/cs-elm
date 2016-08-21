module Components.ConversationSummary exposing (..)

import Html exposing (div, img, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Decoders.Conversation exposing (Conversation)
import Models.User exposing (User)


type Msg
    = NoOp
    | SelectConversation Int


avatar : User -> Html.Html Msg
avatar { avatarUrl } =
    let
        url =
            Maybe.withDefault
                "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mm"
                avatarUrl
    in
        img [ src url ] []


view : Conversation -> Html.Html Msg
view { id, title, messages, userB } =
    div [ onClick <| SelectConversation id ]
        [ avatar userB
        , div []
            [ div [] [ text userB.name ]
            , p [] [ text userB.biography ]
            ]
        ]
