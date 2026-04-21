# Quickstart cheatsheet

## One-time setup
```bash
rokit install
wally install
rojo plugin install
```

## Every session
```bash
rojo serve
# Then in Studio: Rojo plugin → Connect
```

## Before committing
```bash
stylua src            # format
selene src            # lint
```

## Build a local .rbxl
```bash
rojo build default.project.json --output game.rbxl
```

## Publish
```bash
git tag v0.1.0
git push --tags       # triggers deploy workflow
```

Or manually: GitHub → Actions → Deploy to Roblox → Run workflow.

## Adding a dependency
```bash
# Edit wally.toml, add the package under [dependencies]
wally install
```

## Common file locations
- Server logic → `src/server/Services/YourService.luau`
- Client logic → `src/client/Controllers/YourController.luau`
- Shared constants → `src/shared/constants/`
- Shared utilities → `src/shared/modules/`
- Tests → `tests/*.spec.luau`
