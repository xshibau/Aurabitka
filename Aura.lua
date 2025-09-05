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
  
if not getgenv().Key or getBlacklistReason(getgenv().Key) then  
    local reason = getBlacklistReason(getgenv().Key) or "Key bị chặn"  
    game:GetService("Players").LocalPlayer:Kick(reason)  
    return  
end  
  
if isPremiumKey(getgenv().Key) then  
local Scripts = {
   [7939389895] = "https://raw.githubusercontent.com/xshibau/Aurabitka/refs/heads/main/QuanLyMad_Road.lua",
}
local url = Scripts[game.PlaceId] or Scripts[game.GameId]
if url then
    loadstring(game:HttpGetAsync(url))()
    end

else  
    game:GetService("Players").LocalPlayer:Kick("Invalid Key")  
end
