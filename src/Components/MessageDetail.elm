module Components.MessageDetail exposing (..)

import Date exposing (Date)
import Date.Extra exposing (toFormattedString)
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


view : Int -> User -> User -> Message -> Html.Html msg
view myUserId left right { content, dateCreated, senderId } =
    let
        ( user, side ) =
            if left.id == senderId then
                ( left, "left" )
            else
                ( right, "right" )

        involvesMe =
            List.member myUserId [ left.id, right.id ]

        name =
            if ("left" == side && involvesMe) then
                "You"
            else
                user.name
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
                , div
                    [ style
                        [ ( "display", "inline-block" )
                        , ( "text-align", side )
                        ]
                    ]
                    [ div [] [ text name ]
                    , div [] [ text <| dateDisplay dateCreated ]
                    ]
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


dateDisplay : Date -> String
dateDisplay date =
    date
        |> toFormattedString "EEEE, MMMM d, y, h:mm b"
