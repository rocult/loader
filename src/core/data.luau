-- Services
local Players = cloneref(game:GetService("Players"))

-- Types
export type GameData = {
    FFA: boolean,
    Freemium: boolean,
    Unloadable: boolean,
    Url: string,
}

--- All of the supported games
local games: { [number]: GameData } = {
    -- Fish It!
    [6701277882] = {
        FFA = false,
        Freemium = false,
        Unloadable = false,
        Url = "https://api.luarmor.net/files/v3/loaders/b51589a899a693b4da98f86bbfb79c23.lua",
    },
}

-- Grab the current game
local gameData = games[game.GameId]
if gameData == nil then
    Players.LocalPlayer:Kick("This game is not supported!")
end

return gameData
