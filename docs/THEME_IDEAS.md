# Picking your theme

Your scaffold is theme-agnostic. Now pick a concept. Small-scale Roblox games typically fall into a few proven genres — each has different requirements for what you'll build first.

## Obby (obstacle course)

**Loop:** player spawns at start, navigates increasingly difficult jumps, reaches the end, gets a reward, repeats.

**You'll build:** checkpoint system, killbricks, moving platforms, stage teleporters, end-of-obby reward. Maybe a shop for cosmetic trails/effects.

**First service to write:** `CheckpointService` — tracks which stage each player has reached, respawns them at that stage on death.

**Theme variations:** lava obby, ice obby, tower-of-hell style (randomized sections), speedrun leaderboard obby, escape-the-X obby.

**Strength:** easy to scope, clear "done" state, tons of successful examples.

**Weakness:** very crowded genre; needs a hook or gimmick to stand out.

## Simulator

**Loop:** player does a repetitive action (chop trees, swing a sword, click a button), earns a currency, upgrades a tool to earn faster, unlocks new areas, repeat.

**You'll build:** currency system (lots of zeroes — use `BigNumber` or a string representation), upgrade shop, area unlocks, pet/companion system, rebirth mechanic.

**First service to write:** `DataService` (for real, not the skeleton) + `EconomyService` — everything keys off persistent player data.

**Theme variations:** mining, lifting, farming, pet collecting, typing, fishing, literally anything verb-able.

**Strength:** very sticky loop, monetizes well (gamepasses for 2x money, auto-collect, etc.).

**Weakness:** your progression curve has to be tuned — too slow feels grindy, too fast and players finish in an hour.

## Tycoon

**Loop:** player claims a plot, earns passive income, buys expansions that boost income, defends/competes with other tycoons.

**You'll build:** plot claiming, purchasable buttons that spawn structures, dropper/collector system, money-over-head or cash register, PvP or raid mechanic (optional).

**First service to write:** `PlotService` — assigns plots to players, tracks ownership, cleans up on leave.

**Theme variations:** restaurant, factory, airport, military base, magic school, zoo.

**Strength:** players are invested in their plot — high retention.

**Weakness:** more systems to build than obby or simulator; one of the heavier "small" genres.

## Round-based minigame

**Loop:** intermission → teleport players into an arena → game runs for N seconds → winner declared → back to lobby.

**You'll build:** `RoundService` state machine (Lobby / Intermission / InGame / PostGame), teleport/spawn logic, scoring, map voting.

**First service to write:** `RoundService` — everything hangs off its state.

**Theme variations:** murder mystery, hide and seek, parkour race, tag, last-one-standing, trivia.

**Strength:** social, replayable, short sessions.

**Weakness:** needs enough players per server to feel fun; low-population servers feel dead.

## How to choose

Answer two questions honestly:

1. **How much time do you realistically have?** Obby < Simulator < Tycoon < Round-based in rough build effort. If you have 20 hours total, do an obby with a strong gimmick. If you have 200+, tycoon or round-based is viable.

2. **What do you enjoy making?** Level design (obby), systems and numbers (simulator), interconnected mechanics (tycoon), game-feel and rules (round-based). Picking the one that matches your taste matters more than picking the "trendy" one — you'll stick with it.

## Then what?

Once you've picked, tell me which one and I'll:

1. Drop in the starter service for that genre (e.g. `CheckpointService` for an obby, `RoundService` for round-based).
2. Sketch the remote protocol (what the client sends, what the server sends back).
3. List the first 5 things you should build, in order.
