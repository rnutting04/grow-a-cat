# Architecture

## The Init → Start lifecycle

Both server and client use the same pattern. Each service/controller is a `ModuleScript` that returns a table. The bootstrapper does two passes:

1. **Init pass** — every service's `:Init()` runs. This is where you create remotes, wire up references to other services, and set up state. **Do not** do anything that requires other services to have started yet.
2. **Start pass** — every service's `:Start()` runs in its own `task.spawn`. This is where you actually start doing things: listening to events, running loops, processing players.

This guarantees that when `:Start()` runs, every other service has finished `:Init()` and is safe to call.

## Why this pattern?

Straight `Script` files in `ServerScriptService` run in arbitrary order, with no dependency handling. You end up writing `WaitForChild` everywhere and racing yourself. Services solve this by giving you explicit phases.

It's the same idea as [Knit](https://sleitnick.github.io/Knit/) or [AeroGameFramework](https://aerogameframework.com/), stripped to the minimum. If you outgrow this, both are drop-in upgrades.

## Server ↔ Client communication

All remotes go through `RemoteService`. Server creates them:

```lua
-- In a server service
local Remotes = game:GetService("ServerScriptService").Server.Services
local RemoteService = require(Remotes.RemoteService)

function MyService:Init()
    self.buyItemRemote = RemoteService:Event("BuyItem")
    self.buyItemRemote.OnServerEvent:Connect(function(player, itemId)
        -- handle purchase
    end)
end
```

Client finds them under `ReplicatedStorage.Remotes`:

```lua
local Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
local buyItem = Remotes:WaitForChild("BuyItem") :: RemoteEvent
buyItem:FireServer("sword_01")
```

**Always validate on the server.** Never trust client data. Check the player owns the item, has the coins, is close enough to the NPC, etc.

## Shared code

Anything in `src/shared/` is replicated to clients. That means:

- ✅ Constants, pure functions, type definitions, client-safe utilities.
- ❌ Secrets, server-only logic, anything exploit-sensitive.

If a client can see the code, assume exploiters can too.

## DataStore safety

The included `DataService` is a skeleton. For production:

1. Add ProfileService to `wally.toml` under `[server-dependencies]`.
2. Replace `DataService:_load` with `ProfileStore:LoadProfileAsync`.
3. Replace `DataService:_release` with `profile:Release()`.
4. Add a `game:BindToClose` handler that waits for all profiles to finish saving before shutdown.

ProfileService handles session locking (prevents duplicate data if a player rejoins too fast on a different server), corruption rollback, and shutdown-safe saves.

## StreamingEnabled

The project config sets `Workspace.StreamingEnabled = true`. This means parts stream in/out around each player instead of loading the whole map. For small games it just means faster joins. For larger games it's essential.

**Gotcha:** server scripts that assume a part exists in `workspace` may find it nil on the client. Use `WaitForChild` client-side or mark important parts as `ModelStreamingMode = Persistent` / `ReplicationFocus` appropriately.
