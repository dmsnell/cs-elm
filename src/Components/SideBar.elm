module Components.SideBar exposing (..)

import Html exposing (a, div, li, nav, ul, text)
import Html.Events exposing (onClick)
import LoggedIn.Messages exposing (..)


view : Html.Html Msg
view =
    nav []
        [ ul []
            [ li [ onClick (SelectSection SectionSearch) ] [ text "Search" ]
            , li [ onClick (SelectSection SectionMessages) ] [ text "Messages" ]
            , li [ onClick (SelectSection SectionShares) ] [ text "Shares" ]
            , li [ onClick (SelectSection SectionMatches) ] [ text "Matches" ]
            ]
        ]
