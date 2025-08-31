local PremiumKeys = {
--{ Premium Củ }--
"AURA-VCSZS-DBVYU-WKP-RNXZ9-I2DT4",
--( Premium Mới }--
"AURA-YFLCE-W28FW-CUR-IG89V-84WRI", -- 30/9 hết hạn
"AURA-1J9OQ-UDDVE-VDC-7A08J-XMP2D", -- 30/9 hết hạn
"AURA-EAME8-0D19M-R53-LFCMS-KHWE6", -- 30/9 hết hạn
"AURA-HLQB1-UTAMR-ZNA-RQNMP-MAHUU", -- 30/9 hết hạn
"AURA-9EU3F-BB06V-ZCE-EVGIP-W3NOO", -- 30/9 hết hạn
}
local BlacklistKeys = {  
    ["HFmFnVAv3n0Lu8sOynboDODYLVN0kCXy"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN",
    ["f5flrAeJ5Lpp7IdcXcDb4vNBdDXq1oLa"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN",
    ["CGFXmMNWQBMLkIIacfmAEg5IFFoZAtvt"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN",
    ["NOuYvf9BnR4Mnwm6XFBqK8AKVMx7X4NF"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN",
    ["y8W9q6WoCIGsacMdsAondrHs1e370Nom"] = "KEY IS BLACKLIST - KEY ĐÃ BỊ THÊM VÀO DANH SÁCH ĐEN",
}  

local function isPremiumKey(key)  
    if type(key) ~= "string" then return false end
    for _, v in ipairs(PremiumKeys) do  
        if v == key then return true end  
    end  
    return false  
end  

local function getBlacklistReason(key)  
    if type(key) ~= "string" then return nil end
    return BlacklistKeys[key]  
end

if type(getgenv().Key) ~= "string" or getBlacklistReason(getgenv().Key) then  
    local reason = getBlacklistReason(getgenv().Key) or "กรุณาเพิ่มคีย์"  
    game:GetService("Players").LocalPlayer:Kick(reason)  
    return  
end  

if type(_G.Language) == "string" and _G.Language == "Viet" then
    local ScriptsThai = {
       [7018190066] = "https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/Quanly-DeadRailsThai.lua",
    }
    local url = ScriptsThai[game.PlaceId] or ScriptsThai[game.GameId]
    if url then
        local success, err = pcall(function()
            loadstring(game:HttpGetAsync(url))()
        end)
        if not success then
            print("[Luarmor] Failed to load script: Connection timed out.")
            print("[Luarmor] Error: Invalid authentication key. Script execution halted.")
            print("[Luarmor] Unable to connect to API. Please check your internet connection.")    
        end
        return
    end
end

if _G.NewUI == true then
    if isPremiumKey(getgenv().Key) then
        local ScriptsNewUI = {
        [7326934954] = "https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/Quanly99NightNewUi.lua",
        }
        local url = ScriptsNewUI[game.PlaceId] or ScriptsNewUI[game.GameId]
        if url then
            local success, err = pcall(function()
                loadstring(game:HttpGetAsync(url))()
            end)
            if not success then
                print("[Luarmor] Failed to load NewUI script: Connection timed out.")
                print("[Luarmor] Error: Invalid authentication key. Script execution halted.")
                print("[Luarmor] Unable to connect to API. Please check your internet connection.")  
            end
        end
    else
        game:GetService("Players").LocalPlayer:Kick("❌🔑 Invalid Key 🔑❌")
    end
else
    if isPremiumKey(getgenv().Key) then
        local ScriptsPremium = {
           [8014099969] = "https://raw.githubusercontent.com/xshibau/Aurabitka/refs/heads/main/QuanLyPTHFM.luau",
           [7326934954] = "https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/Quanly99Night.lua",
           [7709344486] = "https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/QuanlySaB.lua",
           [7851663243] = "https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/QuanlyStealaMeme.lua",
           [7750955984] = "https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/QuanlyHuntyZombie.lua",
           [7018190066] = "https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/Quanly-DeadRails.lua",
           [7939389895] = "https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/QuanlyMadRoad.lua",
        }
        local url = ScriptsPremium[game.PlaceId] or ScriptsPremium[game.GameId]
        if url then
            local success, err = pcall(function()
                loadstring(game:HttpGetAsync(url))()
            end)
            if not success then
                print("[Luarmor] Failed to load script: Connection timed out.")
                print("[Luarmor] Error: Invalid authentication key. Script execution halted.")
                print("[Luarmor] Unable to connect to API. Please check your internet connection.")  
            end
        end
    else
        game:GetService("Players").LocalPlayer:Kick("❌🔑 Invalid Key 🔑❌")
    end
end
