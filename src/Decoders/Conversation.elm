module Decoders.Conversation exposing (..)

import Json.Decode
import Json.Decode.Pipeline exposing (decode, required)


type alias Conversation =
    List Message


type alias Message =
    { id : Int
    , title : String
    }


decodeConversation : Json.Decode.Decoder Conversation
decodeConversation =
    Json.Decode.at [ "data" ] <|
        Json.Decode.list decodeMessage


decodeMessage : Json.Decode.Decoder Message
decodeMessage =
    decode Message
        |> required "id" (Json.Decode.int)
        |> required "title" (Json.Decode.string)
