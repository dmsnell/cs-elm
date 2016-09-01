module Components.MessageDetail exposing (..)

import Html exposing (div, img, text)
import Html.Attributes exposing (..)
import Models.Message exposing (Message)
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


view : Message -> Html.Html msg
view { content } =
    div []
        [ div [] [ text content ]
        ]
