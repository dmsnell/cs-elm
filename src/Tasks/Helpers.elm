module Tasks.Helpers exposing (..)

import String


baseUrl : String
baseUrl =
    -- "http://communityshare.localhost:5000/"
    "https://app.communityshare.us/"


requestUrl : String -> String
requestUrl path =
    let
        normalizedPath =
            if String.startsWith "/" path then
                String.dropLeft 1 path
            else
                path
    in
        baseUrl ++ normalizedPath
