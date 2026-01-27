--!nolint BuiltinGlobalWrite
--# selene: allow(unscoped_variables)

-- Dependencies
local gameData = require("@core/data")
local lrmApi = require("@core/lrmApi")
local Library = require("@modules/Library")
local Label = require("@modules/Library/Window/Tab/Section/Elements/Label")

-- Configuration
lrmApi.SetScriptId(gameData.Url:split("/")[7]:sub(1, -5)) -- 7th index is the script id, -5 from the end to strip '.lua'

local DISCORD_INVITE = "https://discord.gg/3FaZ3wx2wV"
local LINKVERTISE_REWARDS_URL = "https://ads.luarmor.net/get_key?for=Rocult-OYCBxRfuZPAJ"
local KEY_PATH = "rocult_key.txt"

-- Wait for the game to load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Failsafes...
getgenv().setthreadidentity = getgenv().setthreadidentity or function() end

-- Vars
local library = Library.new()
local defaultKeyStatus

--- Attempt to load the script.
local function loadScript()
    library:Destroy()
    lrmApi.LoadScript()
end

-- Load a key input previously
script_key = script_key :: string?
if isfile(KEY_PATH) then
    local savedKey = readfile(KEY_PATH)
    local keyStatus = lrmApi.CheckKey(savedKey)
    if keyStatus.code == "KEY_VALID" then
        script_key = savedKey
        loadScript()
        return
    else
        delfile(KEY_PATH)
        defaultKeyStatus = lrmApi.GetApiError(keyStatus.code)
    end
end

-- FFA is enabled on the script, a script key is not needed!
if gameData.FFA then
    if not gameData.Freemium then
        script_key = nil
        loadScript()
        return
    end

    -- Freemium support
    if not script_key then
        loadScript()
        return
    end

    if type(script_key) == "string" then
        script_key = script_key:gsub("%s+", "")
        local keyStatus = lrmApi.CheckKey(script_key)
        if keyStatus.code == "KEY_VALID" then
            loadScript()
            return
        end

        defaultKeyStatus = lrmApi.GetApiError(keyStatus.code)
    end
end

-- The user already provided a script_key, check if it's valid.
if type(script_key) == "string" then
    script_key = script_key:gsub("%s+", "")

    local keyStatus = lrmApi.CheckKey(script_key)
    if keyStatus.code == "KEY_VALID" then
        loadScript()
        return
    end
end

-- Initialise the UI
local main = library:Window("rocult")
local home = main:Tab("", true)
local loginTab = home:Section("Login")

local enteredKey = ""
loginTab:Textbox("Enter Key:", false, false, function(t)
    enteredKey = t
end)

if gameData.FFA then
    loginTab:Label("Script is currently keyless!")
end

--- Forward-declare so it can be used earlier.
local keyUrlLabel: Label.Label
loginTab:Button("Confirm", function()
    enteredKey = enteredKey:gsub("%s+", "")
    if enteredKey == "" then
        if gameData.FFA then
            loadScript()
        end
    end

    local keyStatus = lrmApi.CheckKey(enteredKey)

    if keyStatus.code == "KEY_VALID" then
        writefile(KEY_PATH, enteredKey)
        script_key = enteredKey
        loadScript()
    else
        keyUrlLabel:SetText(lrmApi.GetApiError(keyStatus.code))
        task.wait(5)
        keyUrlLabel:SetText(`Discord: {DISCORD_INVITE}`)
    end
end)

loginTab:Button("Get Key (Linkvertise)", function()
    if setclipboard then
        setclipboard(LINKVERTISE_REWARDS_URL)
        keyUrlLabel:SetText("URL copied to your clipboard")
    else
        keyUrlLabel:SetText("Couldn't copy the URL to your clipboard")
    end

    task.wait(3)
    keyUrlLabel:SetText(`Discord: {DISCORD_INVITE}`)
end)

loginTab:Button("Copy Discord Invite", function()
    if setclipboard == nil then
        return
    end

    setclipboard(DISCORD_INVITE)
    keyUrlLabel:SetText("URL copied to your clipboard")
    task.wait(3)
    keyUrlLabel:SetText(`Discord: {DISCORD_INVITE}`)
end)

keyUrlLabel = loginTab:Label(defaultKeyStatus or `Discord: {DISCORD_INVITE}`)