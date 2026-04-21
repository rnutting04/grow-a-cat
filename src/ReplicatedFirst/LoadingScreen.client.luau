--!strict
-- src/ReplicatedFirst/LoadingScreen.client.luau
-- Runs before the default loading screen. Remove the default screen
-- and show our own. Minimal — expand with your own UI.

local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

ReplicatedFirst:RemoveDefaultLoadingScreen()

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.fromScale(1, 1)
bg.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
bg.BorderSizePixel = 0
bg.Parent = gui

local label = Instance.new("TextLabel")
label.Size = UDim2.fromScale(1, 0.1)
label.Position = UDim2.fromScale(0, 0.45)
label.BackgroundTransparency = 1
label.Text = "Loading…"
label.TextColor3 = Color3.fromRGB(230, 230, 240)
label.TextScaled = true
label.Font = Enum.Font.GothamMedium
label.Parent = bg

if not game:IsLoaded() then
	game.Loaded:Wait()
end

bg:Destroy()
