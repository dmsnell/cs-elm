module Decoders.AuthenticationResponse exposing (..)

import Json.Decode
import Json.Decode.Pipeline
import Decoders.User exposing (decodeUser)
import Models.User exposing (User)


type alias AuthenticationResponse =
    { apiKey : String
    , me : User
    }


decodeAuthenticationResponse : Json.Decode.Decoder AuthenticationResponse
decodeAuthenticationResponse =
    Json.Decode.Pipeline.decode AuthenticationResponse
        |> Json.Decode.Pipeline.required "apiKey" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "user" (decodeUser)
