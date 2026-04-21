--!strict
-- src/server/Services/RemoteService.luau
-- Central factory for RemoteEvents/RemoteFunctions so client and server
-- agree on names and structure. All remotes live under ReplicatedStorage.Remotes.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteService = {
	Name = "RemoteService",
}

local remotesFolder: Folder

function RemoteService:Event(name: string): RemoteEvent
	local existing = remotesFolder:FindFirstChild(name)
	if existing and existing:IsA("RemoteEvent") then
		return existing
	end
	local remote = Instance.new("RemoteEvent")
	remote.Name = name
	remote.Parent = remotesFolder
	return remote
end

function RemoteService:Function(name: string): RemoteFunction
	local existing = remotesFolder:FindFirstChild(name)
	if existing and existing:IsA("RemoteFunction") then
		return existing
	end
	local remote = Instance.new("RemoteFunction")
	remote.Name = name
	remote.Parent = remotesFolder
	return remote
end

function RemoteService:Init()
	remotesFolder = Instance.new("Folder")
	remotesFolder.Name = "Remotes"
	remotesFolder.Parent = ReplicatedStorage
end

return RemoteService
