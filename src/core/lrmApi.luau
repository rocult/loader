-- Dependencies
local gameData = require("@core/data")

-- Setup the library
local lrmApi = (loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua")) :: any)()
lrmApi.script_id = gameData.Url:split("/")[7]:sub(1, -5) -- 7th index is the script id, -5 from the end to strip '.lua'

--- Convert the API's error code to a human readable version.
local ERROR_MAP = {
    ["KEY_VALID"] = "Valid key!",
    ["KEY_EXPIRED"] = "Key expired!",
    ["KEY_BANNED"] = "Key is banned!",
    ["KEY_HWID_LOCKED"] = "Reset your HWID in our server!",
    ["KEY_INCORRECT"] = "Key is wrong or deleted!",
    ["KEY_INVALID"] = "Key is in an invalid format!",
    ["SCRIPT_ID_INCORRECT"] = "Incorrect script id!",
    ["SCRIPT_ID_INVALID"] = "Invalid script id!",
    ["INVALID_EXECUTOR"] = "Executor not supported!",
    ["SECURITY_ERROR"] = "Cloudflare error!",
    ["TIME_ERROR"] = "Request took too long!",
    ["UNKNOWN_ERROR"] = "Unknown server error!",
}
export type ErrorCode = keyof<typeof(ERROR_MAP)>

--- Converts the API error code to a human readable version.
local function GetApiError(code: ErrorCode): string
    return ERROR_MAP[code] or "Key check failed: " .. code
end

--- Set the script id to load.
local function SetScriptId(scriptId: string)
    lrmApi.script_id = scriptId
end

--- The Luarmor key check api.
return {
    GetApiError = GetApiError,

    SetScriptId = SetScriptId,
    CheckKey = function(key: string)
        return lrmApi.check_key(key) :: {
            code: ErrorCode,
            message: string,
        }
    end,
    LoadScript = function()
        return lrmApi.load_script()
    end,
    PurgeCache = function()
        return lrmApi.purge_cache()
    end,
}
