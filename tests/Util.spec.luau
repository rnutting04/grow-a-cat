--!strict
-- tests/Util.spec.luau
-- Example TestEZ spec. Run with Lune or TestEZ's runner inside Studio.
-- To execute inside Studio: require TestEZ, point it at this folder.

return function()
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Util = require(ReplicatedStorage.Shared.modules.Util)

	describe("Util", function()
		describe("lerp", function()
			it("interpolates linearly", function()
				expect(Util.lerp(0, 10, 0.5)).to.equal(5)
				expect(Util.lerp(0, 10, 0)).to.equal(0)
				expect(Util.lerp(0, 10, 1)).to.equal(10)
			end)
		end)

		describe("round", function()
			it("rounds to nearest integer by default", function()
				expect(Util.round(1.4)).to.equal(1)
				expect(Util.round(1.6)).to.equal(2)
			end)

			it("rounds to step", function()
				expect(Util.round(7, 5)).to.equal(5)
				expect(Util.round(8, 5)).to.equal(10)
			end)
		end)

		describe("shuffle", function()
			it("keeps the same elements", function()
				local source = { 1, 2, 3, 4, 5 }
				local shuffled = Util.shuffle(source)
				table.sort(shuffled)
				expect(shuffled[1]).to.equal(1)
				expect(shuffled[5]).to.equal(5)
				expect(#shuffled).to.equal(5)
			end)

			it("does not mutate the input", function()
				local source = { 1, 2, 3 }
				Util.shuffle(source)
				expect(source[1]).to.equal(1)
				expect(source[2]).to.equal(2)
				expect(source[3]).to.equal(3)
			end)
		end)
	end)
end
