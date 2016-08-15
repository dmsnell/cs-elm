module Decoders.AuthenticationResponse exposing (..)

import Json.Decode
import Json.Decode.Pipeline


type alias AuthenticationResponse =
    { apiKey : String
    }


decodeAuthenticationResponse : Json.Decode.Decoder AuthenticationResponse
decodeAuthenticationResponse =
    Json.Decode.Pipeline.decode AuthenticationResponse
        |> Json.Decode.Pipeline.required "apiKey" (Json.Decode.string)
