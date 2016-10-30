module Pastebin
export
    paste!,
    delpaste!,
    getraw,
    content,
    success

using Requests
include("TypeDeclarations.jl")

const API = "http://pastebin.com/api/api_post.php"

function paste!(client::PastebinClient, title::AbstractString, text::AbstractString, expiration::Expiration=NEVER, access::Access=PUBLIC)
    userKey = client.userKey
    devKey = client.devKey

    format = "Text"
    accessString = 1
    expirationNode = ""
    accessNode = 0

    if expiration == NEVER
        expirationNode = "N"
    elseif expiration == TEN_M
        expirationNode = "10M"
    elseif expiration == HOUR
        expirationNode = "1H"
    elseif expiration == DAY
        expirationNode = "1D"
    elseif expiration == WEEK
        expirationNode = "1W"
    elseif expiration == TWO_WEEKS
        expirationNode = "2W"
    elseif expiration == MONTH
        expirationNode = "1M"
    end

    if access == PUBLIC
        accessNode = 0
    elseif access == PRIVATE
        accessNode = isempty(userKey) ? error("For a private paste, providing a USER_KEY is required. Exiting.") : 2
    elseif access == UNLISTED
        access = 1
    end

    data = Dict(
        "api_option"            => "paste",
        "api_paste_private"     => accessString,
        "api_paste_name"        => title,
        "api_paste_expire_date" => expirationNode,
        "api_paste_format"      => format,
        "api_dev_key"           => devKey,
        "api_paste_code"        => text
    )

    if !isnull(userKey)
        data["api_user_key"] = get(userKey)
    end

    response = readall(Requests.post(API, data=data))
    contains("Bad API Request", response) ? PastebinResponse(false, response) : PastebinResponse(true, response)
end

function delpaste!(client::PastebinClient, key::PasteKey)
    data = Dict(
        "api_option"            => "delete",
        "api_dev_key"           => client.devKey,
        "api_paste_key"         => key.key,
    )

    if !isnull(client.userKey)
        data["api_user_key"] = get(client.userKey)
    end

    response = readall(Requests.post(API, data=data))
    contains("Bad API Request", response) ? PastebinResponse(false, response) : PastebinResponse(true, response)
end

function getraw(key::PasteKey)
    response = readall(Requests.get("http://pastebin.com/raw/" * key.key))
    contains("Bad API Request", response) ? PastebinResponse(false, response) : PastebinResponse(true, response)
end

content(resp::PastebinResponse) = resp.response
success(resp::PastebinResponse) = resp.successful

end # end of module
