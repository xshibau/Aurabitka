local ScriptsPremium = {
 [7326934954] = "https://raw.githubusercontent.com/xshibau/Aurabitka/refs/heads/main/Quanly99Night.lua",
 [7709344486] = "https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/QuanlySaB.lua",
 [7851663243] = "https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/QuanlyStealaMeme.lua",
 [7750955984] = "https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/QuanlyHuntyZombie.lua",
 [7018190066] = "https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/Quanly-DeadRails.lua",
 [7939389895] = "https://raw.githubusercontent.com/xshibau/Aurabitka/refs/heads/main/QuanlyMadRoad.lua",
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
