if game.GameId == 0 then
  loadstring(game:HttpGet(""))()
elseif game.GameId == 1 then
  loadstring(game:HttpGet(""))()
else
 local player = game.Players.LocalPlayer or game.Players.PlayerAdded:Wait()
 player:Kick("[Aura Hub]: Load Failed - Script Not Support")
end
