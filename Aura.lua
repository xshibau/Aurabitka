local PremiumKeys = {  
    "JRTtibghwXeykmqzh4r3oCvzf35xtb",  
}  
  
local BlacklistKeys = {  
    ["abc123"] = "Hành vi gian lận bị phát hiện",  
    ["badkey456"] = "Vi phạm điều khoản sử dụng",  
    ["xyz789"] = "Key đã bị thu hồi do lạm dụng"  
}  
  
local function isPremiumKey(key)  
    for _, v in ipairs(PremiumKeys) do  
        if v == key then  
            return true  
        end  
    end  
    return false  
end  
  
local function getBlacklistReason(key)  
    return BlacklistKeys[key]  
end  
  
if not aurahub.key or getBlacklistReason(aurahub.key) then  
    local reason = getBlacklistReason(aurahub.key) or "Key bị chặn"  
    game:GetService("Players").LocalPlayer:Kick(reason)  
    return  
end  
  
if isPremiumKey(aurahub.key) then  
local base = "https://raw.github.io/"
local user = "xshibau/"
local repo = "Aurabitka/"
local branch = "refs/heads/main/"
local filePart = {
    ["00000000"] = {"script/", "00000000", ".lua"},
    ["11111111"] = {"script/", "11111111", ".lua"}
}

local function LoadScript(gameId)
    local parts = filePart[gameId]
    if not parts then return end
    local url = base .. user .. repo .. branch .. table.concat(parts)
    loadstring(game:HttpGet(url))()
end

LoadScript(tostring(game.GameId))
else  
    game:GetService("Players").LocalPlayer:Kick("Invalid Key")  
end
