module Components.MessageDetail exposing (..)

import Html exposing (div, img, text)
import Html.Attributes exposing (..)
import Decoders.Conversation exposing (Message)
import Models.User exposing (User)


userProfile : User -> Html.Html msg
userProfile user =
    div []
        [ img
            [ src user.avatarUrl
            , style
                [ ( "height", "64px" )
                , ( "width", "64px" )
                , ( "border-radius", "32px" )
                ]
            ]
            []
        , div [] [ text user.name ]
        ]


view : Message -> User -> Html.Html msg
view { content } user =
    div []
        [ userProfile user
        , div [] [ text content ]
        ]
