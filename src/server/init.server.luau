--!strict
-- src/server/init.server.luau
-- Server entry point. Runs once when the server starts.
-- Bootstraps every ModuleScript under src/server/services that exposes :Start().

local ServerScriptService = game:GetService("ServerScriptService")

local Server = ServerScriptService:WaitForChild("Server")
local Services = Server:WaitForChild("Services")

type Service = {
	Name: string?,
	Init: ((self: Service) -> ())?,
	Start: ((self: Service) -> ())?,
}

local services: { Service } = {}

-- Load everything first so services can reference each other in :Init()
for _, moduleScript in Services:GetChildren() do
	if moduleScript:IsA("ModuleScript") then
		local ok, result = pcall(require, moduleScript)
		if ok and type(result) == "table" then
			result.Name = result.Name or moduleScript.Name
			table.insert(services, result)
		else
			warn(`[Server] Failed to require {moduleScript.Name}: {result}`)
		end
	end
end

-- Init phase: wire up references, create remotes, etc.
for _, service in services do
	if service.Init then
		local ok, err = pcall(service.Init, service)
		if not ok then
			warn(`[Server] {service.Name}:Init() errored: {err}`)
		end
	end
end

-- Start phase: begin doing actual work
for _, service in services do
	if service.Start then
		task.spawn(function()
			local ok, err = pcall(service.Start, service)
			if not ok then
				warn(`[Server] {service.Name}:Start() errored: {err}`)
			end
		end)
	end
end

print(`[Server] {#services} services online.`)
