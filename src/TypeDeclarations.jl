using Requests

export
    PastebinClient,
    PastebinResponse,
    PasteKey,
    NEVER, TEN_M, HOUR, DAY, WEEK, TWO_WEEKS, MONTH,
    PUBLIC, UNLISTED, PRIVATE

@enum Expiration NEVER=1 TEN_M=2 HOUR=3 DAY=4 WEEK=5 TWO_WEEKS=6 MONTH=7
@enum Access PUBLIC=0 UNLISTED=1 PRIVATE=2

immutable PastebinClient
    devKey::AbstractString
    userKey::Nullable{AbstractString}

    PastebinClient(devKey::AbstractString) = new(devKey, Nullable{AbstractString}())
    PastebinClient(devKey::AbstractString, userKey::AbstractString) = new(devKey, userKey)

    # function to auto generate the user key
    function PastebinClient(devKey::AbstractString, username::AbstractString, password::AbstractString)
        data = Dict(
            "api_dev_key" => devKey,
            "api_user_name" => username,
            "api_user_password" => password,
        )

        response = readall(Requests.post("http://pastebin.com/api/api_login.php", data=data))
        new(devKey, response)
    end

end

immutable PastebinResponse
    successful::Bool
    response::AbstractString

    PastebinResponse(successful::Bool, response::AbstractString) = new(successful, response)
end

immutable PasteKey
    key::AbstractString

    PasteKey(key::AbstractString) = new(key)
end