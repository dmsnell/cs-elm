module Components.SideBar exposing (..)

import Html exposing (a, div, li, nav, ul, text)
import Html.Events exposing (onClick)


type Msg
    = Select Section
    | NoOp


type Section
    = Search
    | Messages
    | Shares
    | Matches


update : Msg -> Maybe Section
update msg =
    case msg of
        Select section ->
            Just section

        _ ->
            Nothing


view : Html.Html Msg
view =
    nav []
        [ ul []
            [ li [ onClick (Select Search) ] [ text "Search" ]
            , li [ onClick (Select Messages) ] [ text "Messages" ]
            , li [ onClick (Select Shares) ] [ text "Shares" ]
            , li [ onClick (Select Matches) ] [ text "Matches" ]
            ]
        ]
