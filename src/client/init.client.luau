--!strict
-- src/client/init.client.luau
-- Client entry point. Mirrors the server pattern: Init() then Start().

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")
local Client = playerScripts:WaitForChild("Client")
local Controllers = Client:WaitForChild("Controllers")

type Controller = {
	Name: string?,
	Init: ((self: Controller) -> ())?,
	Start: ((self: Controller) -> ())?,
}

local controllers: { Controller } = {}

for _, moduleScript in Controllers:GetChildren() do
	if moduleScript:IsA("ModuleScript") then
		local ok, result = pcall(require, moduleScript)
		if ok and type(result) == "table" then
			result.Name = result.Name or moduleScript.Name
			table.insert(controllers, result)
		else
			warn(`[Client] Failed to require {moduleScript.Name}: {result}`)
		end
	end
end

for _, controller in controllers do
	if controller.Init then
		local ok, err = pcall(controller.Init, controller)
		if not ok then
			warn(`[Client] {controller.Name}:Init() errored: {err}`)
		end
	end
end

for _, controller in controllers do
	if controller.Start then
		task.spawn(function()
			local ok, err = pcall(controller.Start, controller)
			if not ok then
				warn(`[Client] {controller.Name}:Start() errored: {err}`)
			end
		end)
	end
end

print(`[Client] {#controllers} controllers online.`)
