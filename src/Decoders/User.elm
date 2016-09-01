module Decoders.User exposing (decodeUser)

import Json.Decode exposing (Decoder, andThen, bool, int, maybe, string, succeed)
import Json.Decode.Pipeline exposing (decode, required)
import String
import Models.User as User
import Models.User exposing (..)


decodeUser : Decoder User.User
decodeUser =
    decode User
        |> required "id" int
        |> required "name" string
        |> required "picture_url" (string `andThen` decodeAvatar)
        |> required "active" bool
        |> required "bio" string
        |> required "zipcode" (string `andThen` decodeZipcode)
        |> required "website" (maybe string)
        |> required "is_administrator" (bool `andThen` decodeSiteRole)
        |> required "is_educator" (bool `andThen` decodeMemberRole)


decodeAvatar : String -> Decoder String
decodeAvatar url =
    succeed <|
        if String.isEmpty url then
            defaultAvatarUrl
        else
            url


decodeZipcode : String -> Decoder (Maybe Int)
decodeZipcode z =
    succeed <|
        Result.toMaybe (String.toInt z)


decodeSiteRole : Bool -> Decoder SiteRole
decodeSiteRole role =
    succeed <|
        case role of
            True ->
                Administrator

            False ->
                Guest


decodeMemberRole : Bool -> Decoder MemberRole
decodeMemberRole role =
    succeed <|
        case role of
            True ->
                Educator

            False ->
                Partner
