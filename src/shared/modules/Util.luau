--!strict
-- src/shared/modules/Util.luau
-- Small, dependency-free helpers used across client and server.

local Util = {}

function Util.lerp(a: number, b: number, t: number): number
	return a + (b - a) * t
end

function Util.round(n: number, step: number?): number
	local s = step or 1
	return math.floor(n / s + 0.5) * s
end

function Util.weightedPick<T>(entries: { { value: T, weight: number } }): T
	local total = 0
	for _, e in entries do
		total += e.weight
	end
	local roll = math.random() * total
	local acc = 0
	for _, e in entries do
		acc += e.weight
		if roll <= acc then
			return e.value
		end
	end
	return entries[#entries].value
end

function Util.shuffle<T>(list: { T }): { T }
	local copy = table.clone(list)
	for i = #copy, 2, -1 do
		local j = math.random(i)
		copy[i], copy[j] = copy[j], copy[i]
	end
	return copy
end

return Util
