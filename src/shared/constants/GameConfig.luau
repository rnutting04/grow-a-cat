--!strict
-- src/shared/constants/GameConfig.luau
-- Central place for tunable numbers. Changing values here beats hunting
-- through code. Both client and server can read this.

local GameConfig = {
	-- Economy
	STARTING_COINS = 75,
	COIN_PICKUP_VALUE = 5,

	-- Progression
	XP_PER_LEVEL = 100,
	MAX_LEVEL = 50,

	-- Movement
	DEFAULT_WALK_SPEED = 16,
	SPRINT_WALK_SPEED = 24,
	JUMP_POWER = 50,

	-- Round / match (if applicable)
	ROUND_DURATION_SECONDS = 120,
	INTERMISSION_SECONDS = 15,

	-- Debug flags — STRIP OR GATE BEFORE PUBLISHING
	DEBUG = {
		VERBOSE_LOGGING = false,
		GOD_MODE = false,
	},
}

table.freeze(GameConfig.DEBUG)
table.freeze(GameConfig)

return GameConfig
