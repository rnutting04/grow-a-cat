# My Roblox Game

A production-ready Roblox project using Rojo, Wally, and a clean service/controller architecture. Edit in VS Code, live-sync to Studio, ship through GitHub Actions.

## What you get

- **Rojo 7** — file-system-backed Studio sync, so your code lives in git, not `.rbxl`.
- **Wally** — package manager for Luau libraries.
- **Rokit** — pins exact tool versions so the whole team (or future-you) has a reproducible environment. (Successor to Aftman, which is deprecated.)
- **Selene + StyLua** — linting and formatting, enforced in CI.
- **Service/Controller pattern** — server services and client controllers auto-discovered and lifecycled (`Init` → `Start`).
- **CI/CD** — GitHub Actions builds `.rbxl` on every push; tag a release to auto-publish to Roblox.

## Prerequisites

1. **Roblox Studio** installed.
2. **VS Code** with the recommended extensions (it will prompt you on first open).
3. **Rokit** — see install steps below. Pins every other tool.
4. **Rojo Studio plugin** — install from the Roblox plugin marketplace or via `rojo plugin install`.

## First-time setup

```bash
# Install Rokit (one-time, global) — see docs/INSTALL.md for Windows
# macOS & Linux:
curl -sSf https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.sh | bash

# Then in this repo:
rokit install            # fetches Rojo, Wally, Selene, StyLua, Lune
wally install            # fetches Luau packages into /Packages
```

Open VS Code in the project root. Install the recommended extensions when prompted.

## Daily workflow

```bash
rojo serve               # start the live-sync server
```

In Roblox Studio: open a new baseplate (or your existing place file), click the **Rojo** plugin button, press **Connect**. Your `src/` folder is now live-synced. Edit a `.luau` file in VS Code, save, see the change in Studio instantly.

Press **F5** in Studio to playtest. Press **Stop** to return to editing.

## Project layout

```
src/
├── client/              → StarterPlayerScripts (runs on each player's device)
│   ├── init.client.luau → bootstraps all controllers
│   └── Controllers/     → auto-loaded modules with :Init()/:Start()
├── server/              → ServerScriptService (runs on the Roblox server)
│   ├── init.server.luau → bootstraps all services
│   └── Services/        → auto-loaded modules with :Init()/:Start()
├── shared/              → ReplicatedStorage.Shared (both sides can require)
│   ├── constants/       → game config, enums
│   └── modules/         → utilities, types
└── ReplicatedFirst/     → loads before anything else (loading screen)
```

## Adding code

**New server service:** drop a `ModuleScript` in `src/server/Services/`. Return a table. If it has `:Init()` it runs during init phase; if it has `:Start()` it runs after all services are initialized.

**New client controller:** same pattern, in `src/client/Controllers/`.

**New shared module:** put it in `src/shared/modules/` and require via `ReplicatedStorage.Shared.modules.YourModule`.

## Publishing to Roblox

**Manual (first time):**

1. `rojo build default.project.json --output game.rbxl`
2. In Studio: File → Open → `game.rbxl`.
3. File → Publish to Roblox → create a new experience or pick an existing one.

**Automated (recommended after first publish):**

1. In Roblox Creator Dashboard, note your **Universe ID** and **Place ID**.
2. Creator Hub → Open Cloud API Keys → create a key with **Place Publishing** scope for your universe.
3. In your GitHub repo: Settings → Secrets → Actions → add:
   - `ROBLOX_API_KEY`
   - `ROBLOX_UNIVERSE_ID`
   - `ROBLOX_PLACE_ID`
4. Tag a release: `git tag v0.1.0 && git push --tags`. The Deploy workflow publishes automatically.
5. Or trigger manually: Actions tab → Deploy → Run workflow → choose `Saved` (draft) or `Published` (live).

## Linting and formatting

```bash
stylua src                 # format all files
stylua --check src         # CI: verify formatting
selene src                 # lint
```

Both run on every PR via `.github/workflows/ci.yml`.

## Useful docs

- Rojo: https://rojo.space/docs
- Wally: https://wally.run
- Roblox Open Cloud: https://create.roblox.com/docs/cloud
- Luau: https://luau.org/getting-started

## Next steps

1. Replace the `DataService` skeleton with [ProfileService](https://madstudioroblox.github.io/ProfileService/) for safe datastore handling.
2. Add your theme — edit `src/shared/constants/GameConfig.luau` with your balance numbers.
3. Build out services: shop, inventory, combat, whatever your game needs.
