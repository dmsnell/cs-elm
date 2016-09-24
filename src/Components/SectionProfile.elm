module Components.SectionProfile exposing (..)

import Html exposing (div, h1, img, text)
import Html.Attributes exposing (..)
import LoggedIn.Messages exposing (..)
import Models.User exposing (User)


view : Maybe User -> Html.Html Msg
view user =
    case user of
        Nothing ->
            div []
                [ text "Loading profile…" ]

        Just { avatarUrl, biography, name } ->
            div []
                [ h1 [] [ text name ]
                , img
                    [ src avatarUrl
                    , style
                        [ ( "width", "128px" )
                        , ( "border-radius", "64px" )
                        ]
                    ]
                    []
                , div [] [ text biography ]
                ]
