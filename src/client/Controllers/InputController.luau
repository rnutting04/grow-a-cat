--!strict
-- src/client/Controllers/InputController.luau
-- Wraps ContextActionService into semantic "actions" the rest of the
-- client code can subscribe to. Rebindable, touch+keyboard+gamepad.

local ContextActionService = game:GetService("ContextActionService")
local Enum_ = Enum

local InputController = {
	Name = "InputController",
}

local listeners: { [string]: { (pressed: boolean) -> () } } = {}

function InputController:OnAction(actionName: string, callback: (pressed: boolean) -> ()): () -> ()
	listeners[actionName] = listeners[actionName] or {}
	table.insert(listeners[actionName], callback)

	return function()
		local list = listeners[actionName]
		if not list then
			return
		end
		local i = table.find(list, callback)
		if i then
			table.remove(list, i)
		end
	end
end

local function bind(actionName: string, ...: Enum.KeyCode | Enum.UserInputType)
	ContextActionService:BindAction(actionName, function(_, state)
		local pressed = state == Enum_.UserInputState.Begin
		for _, cb in listeners[actionName] or {} do
			task.spawn(cb, pressed)
		end
		return Enum_.ContextActionResult.Pass
	end, false, ...)
end

function InputController:Start()
	bind("Interact", Enum_.KeyCode.E, Enum_.KeyCode.ButtonX)
	bind("Sprint", Enum_.KeyCode.LeftShift, Enum_.KeyCode.ButtonL3)
	bind("Menu", Enum_.KeyCode.M, Enum_.KeyCode.ButtonStart)
end

return InputController
