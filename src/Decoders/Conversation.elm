module Decoders.Conversation exposing (..)

import Json.Decode
import Json.Decode.Pipeline


type alias Conversation =
    { id : Int
    , title : String
    }


decodeConversation : Json.Decode.Decoder Conversation
decodeConversation =
    Json.Decode.Pipeline.decode Conversation
        |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "title" (Json.Decode.string)
