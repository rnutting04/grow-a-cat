--!strict
-- src/server/Services/DataService.luau
-- Persistent player data. Skeleton only — swap in ProfileService
-- (loleris/profileservice) for production-safe DataStore usage.

local Players = game:GetService("Players")

export type PlayerData = {
	Coins: number,
	Level: number,
	XP: number,
	Inventory: { string },
	FirstJoin: number,
}

local DEFAULT_DATA: PlayerData = {
	Coins = 0,
	Level = 1,
	XP = 0,
	Inventory = {},
	FirstJoin = 0,
}

local DataService = {
	Name = "DataService",
}

local cache: { [Player]: PlayerData } = {}

function DataService:Get(player: Player): PlayerData?
	return cache[player]
end

function DataService:_load(player: Player)
	-- In production, call ProfileService here.
	-- For now we just hand out defaults so the pipeline works end-to-end.
	local data = table.clone(DEFAULT_DATA)
	data.FirstJoin = os.time()
	cache[player] = data
end

function DataService:_release(player: Player)
	-- TODO: :Release() the ProfileService profile here.
	cache[player] = nil
end

function DataService:Start()
	for _, player in Players:GetPlayers() do
		self:_load(player)
	end
	Players.PlayerAdded:Connect(function(player)
		self:_load(player)
	end)
	Players.PlayerRemoving:Connect(function(player)
		self:_release(player)
	end)
end

return DataService
