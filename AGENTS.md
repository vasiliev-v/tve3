# Agent Guide (Trolls vs Elves 2)

This is a Dota 2 custom game project named `trollnelves2`. It has the standard `content/` (client assets) and `game/` (server scripts) split.

## Project Layout
- `content/trollnelves2/panorama/layout/custom_game/`: Panorama UI source. TypeScript lives here and compiles to colocated `.js` files.
- `content/trollnelves2/panorama/images/`: UI images and sprites.
- `content/trollnelves2/maps/`: Workshop map files.
- `game/trollnelves2/scripts/vscripts/`: Lua gameplay logic (abilities, game mode, AI, etc).
- `game/trollnelves2/scripts/kv/`: KeyValues (abilities, units, items, settings).

## Build and Dev Workflow
- `npm install`: installs dependencies and symlinks the addon into your Dota 2 install (see `scripts/install.js`).
- `npm run dev`: watches Panorama TS and recompiles to JS on change.
- `npm run build`: one-off Panorama TS compile.
- `npm run launch`: launches Dota 2 tools and runs `npm run dev`.
- `npm run lint`: run ESLint (there is also `npm run lint-nofix`).

Never edit generated Panorama `.js` files directly. Always change the `.ts` source under `content/trollnelves2/panorama/layout/custom_game/`.

## API Typing and Discovery
- Panorama TS uses `@moddota/panorama-types` (already in `devDependencies`). Use these types for strong autocomplete and API discovery.
- Lua API types can be discovered via `@moddota/dota-lua-types` (installed as a dev dependency).
- For guides and best practices, consult moddota.com (Panorama, VScript, tooling tips).
