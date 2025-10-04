if game.GameId == 7326934954 then
 loadstring(game:HttpGet("https://raw.githubusercontent.com/xshibau/Aurabitka/refs/heads/main/Quanly99Night.lua"))()
elseif game.GameId == 8066283370 then
 loadstring(game:HttpGet("https://raw.githubusercontent.com/xshibau/Aurabitka/refs/heads/main/QuanlyBulAZoo.luau"))()
elseif game.GameId == 7709344486 then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/QuanlySaB.lua"))()
elseif game.GameId == 7750955984 then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/QuanlyHuntyZombie.lua"))()
elseif game.GameId == 7851663243 then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/ziugpro/Tool-Hub/refs/heads/main/QuanlyStealaMeme.lua"))()
elseif game.GameId == 7018190066 then
loadstring(game:HttpGet("https://raw.githubusercontent.com/xshibau/Aurabitka/refs/heads/main/Quanly-DeadRails.lua"))()
elseif game.GameId == 7939389895 then
 loadstring(game:HttpGet("https://raw.githubusercontent.com/xshibau/Aurabitka/refs/heads/main/QuanlyMadRoad.lua"))()
else
 local player = game.Players.LocalPlayer or game.Players.PlayerAdded:Wait()
 player:Kick("[Aura Hub]: Load Failed - Script Not Support")
end
