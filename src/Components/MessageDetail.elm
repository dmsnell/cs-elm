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


view : User -> User -> Message -> Html.Html msg
view left right { content, senderId } =
    let
        ( user, side ) =
            if left.id == senderId then
                ( left, "left" )
            else
                ( right, "right" )
    in
        div
            [ style
                [ ( "background-color", "#ddd" )
                , ( "margin", "1em" )
                , ( "padding", "1em" )
                , ( "border-radius", "8px" )
                ]
            ]
            [ div
                [ style [ ( "float", side ) ] ]
                [ img
                    [ src user.avatarUrl
                    , style
                        [ ( "float", side )
                        , ( "margin-bottom", "1em" )
                        , ( if side == "left" then
                                "margin-right"
                            else
                                "margin-left"
                          , "1em"
                          )
                        , ( "width", "32px" )
                        ]
                    ]
                    []
                , text user.name
                ]
            , div [ style [ ( "clear", "both" ) ] ] []
            , div
                [ style
                    [ ( "background-color", "#eaeaea" )
                    , ( "padding", "0.5em" )
                    , ( "border-radius", "8px" )
                    , ( "text-align", side )
                    ]
                ]
                [ text content ]
            ]
