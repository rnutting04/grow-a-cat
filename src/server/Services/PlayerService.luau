--!strict
-- src/server/Services/PlayerService.luau
-- Handles player lifecycle: join, leave, character spawning.

local Players = game:GetService("Players")

local PlayerService = {
	Name = "PlayerService",
}

local function onPlayerAdded(player: Player)
	print(`[PlayerService] {player.Name} joined.`)

	player.CharacterAdded:Connect(function(character)
		-- Hook into character spawns here (e.g. load inventory, apply skins)
		local humanoid = character:WaitForChild("Humanoid") :: Humanoid
		humanoid.WalkSpeed = 16
	end)
end

local function onPlayerRemoving(player: Player)
	print(`[PlayerService] {player.Name} leaving. Save data here.`)
	-- TODO: save profile via DataService
end

function PlayerService:Start()
	for _, player in Players:GetPlayers() do
		task.spawn(onPlayerAdded, player)
	end
	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)
end

return PlayerService
