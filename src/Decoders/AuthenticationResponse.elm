module Decoders.AuthenticationResponse exposing (..)

import Json.Decode
import Json.Decode.Pipeline

import Models.AuthenticationResponse exposing (AuthenticationResponse)
import Models.User exposing (User)


decodeAuthenticationResponse : Json.Decode.Decoder AuthenticationResponse
decodeAuthenticationResponse =
    Json.Decode.Pipeline.decode AuthenticationResponse
        |> Json.Decode.Pipeline.required "apiKey" (Json.Decode.string)
        |> Json.Decode.Pipeline.required "user" (decodeUser)


decodeUser : Json.Decode.Decoder User
decodeUser =
    Json.Decode.Pipeline.decode User
        |> Json.Decode.Pipeline.required "id" (Json.Decode.int)
        |> Json.Decode.Pipeline.required "email" (Json.Decode.string)

