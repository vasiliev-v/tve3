# Restricted client mode

Restricted mode is enabled only when Lua's `dedicatedServerKey` equals
`Invalid_NotOnDedicatedServer`. This is a UX/network-traffic guard, not an
authorization boundary. The ASP.NET Core API remains responsible for authorization.

## Investigation and request inventory

The investigation covered both junction-backed source trees, including current and
legacy Panorama scripts/layouts, Lua helpers, listeners, timers, chat/console paths,
and item KV callbacks. The pre-edit findings and proposed changes were reported in
the task before editing. Two details were refined during verification: `RequestXp`
is commented out, and the native redemption list includes `little_spider` and
`item_ghosttown`, rather than the unrelated `item_flicker`.

`settings.lua` creates the global key with `GetDedicatedServerKeyV3("1")`.
There were no existing sentinel checks or JS copies. Every HTTP call attaches the
key in `Dedicated-Server-Key`; normal/tournament/clan match payload construction also
sets `data.Key`. No HTTP requests originate directly in Panorama. The Lua HTTP calls
run on the game server, including the local/listen-server session being restricted.

`GameRules.server` is currently `https://localhost:7133/test/`, assigned in
`addon_game_mode.lua`. That URL and all routes remain unchanged. Routes below are
relative to it except the debug endpoint.

| Method | Route | Caller | Classification and evidence |
| --- | --- | --- | --- |
| GET | `vip/{steam}` | `Shop.RequestDonate`, speed 1 | READ: loads account, inventory, settings, rewards, quests, statistics |
| GET | `vip2/{steam}` | Same, speed 2 | READ: same response consumers |
| GET | `vip3/{steam}` | Same, speed 4 | READ: same response consumers |
| GET | `vip4/{steam}` | Same, 1x1 | READ: same response consumers |
| GET | `all/{speed}` | `Stats.RequestDataTop10` | READ: leaderboard; also refreshes profiles with GET |
| GET | `lasttop/{speed}` | `Stats.RequestLastTop` | READ: seasonal leaderboard |
| GET | `datetime` | `Stats.RequestDataTime` | READ: battle-pass/reward timers |
| GET | `bpday` | `Shop.RequestBpDay` | READ: daily quest definitions |
| GET | `xp/{steam}` | `Stats.RequestXp` | READ, inactive inside a Lua block comment |
| POST | API base | `Stats.SendData` | WRITE: match statistics/rating submission |
| POST | API base | `Clanwars.SendData` | WRITE: clan match submission |
| POST | API base | `Shop.GetVip` | WRITE: persisted cosmetic defaults/settings or redeemed items |
| POST | `buy/` | `Shop.GetSkill` | WRITE: purchases/upgrades persistent skills |
| POST | `buy/` | `Shop:BuyShopItem` | WRITE: spends currency, buys inventory/pass |
| POST | `buy/` | `Shop:BuyOpenChests` | WRITE: consumes chest, grants reward |
| POST | `coint/` | `Shop.GetGem` | WRITE: currency grant |
| POST | `postrewards/` | `Shop:EventRewards` | WRITE: claims daily reward |
| POST | `battlepass/` | `Shop:EventBattlePass` | WRITE: claims free/premium pass reward |
| POST | `postxp/` | `Shop.GetXpBattlepass` | WRITE: quest XP grant |
| POST | `gemchest/` | `Shop.GetGetGemChest` | WRITE: quest chest grant |
| POST | `dayquest/` | `Shop.GetDayDone` | WRITE: quest progress/completion |
| POST | `https://tve4.eu/debug/` | `Error_debug.SendData` | WRITE: stores error reports |

Total: 13 active WRITE call sites, eight active READ call sites, one commented READ.
No shared generic POST wrapper exists. Every active POST is a confirmed write, but
the implementation still guards its named helper rather than monkey-patching HTTP.
There are no active GET mutations identified from client-side traces. The API source
is not present, so hidden server-side behavior of READ endpoints is unverified;
their classification follows payloads and response consumers. No unresolved active
client dispatch path was intentionally left unguarded.

## State and implementation

- `IsRestrictedClient()` in `settings.lua` is the single literal comparison.
- The existing `Shop` net table publishes `restricted_client`, containing
  `isRestrictedClient` and the native redemption item names. No raw key is exposed.
- `scripts/restricted_client.js`, loaded first in the manifest, supplies
  `GameUI.CustomUIConfig().IsRestrictedClient()` and control registration. It accepts
  replicated boolean or numeric flags and updates already-created panels when the
  flag arrives. New panels use the current flag immediately.
- Registered write controls have `enabled=false`, opacity `0.35`, and saturation `0`.
  Normal mode does not change their existing enabled/style state. If the replicated
  flag changes back, the helper restores the state it changed, including controls
  that were already disabled. Deleted panels are removed from its registry.
- JS action guards run before optimistic UI changes, local selection events, or
  cooldown scheduling. Lua write helpers return before creating HTTP requests or
  changing request data. Higher-level Lua guards also avoid optimistic inventory
  upgrades, item consumption, chest notifications, and saved-default counters.
- Existing GET conditions, including pre-existing cheat-mode checks, remain intact.
  Before Panorama receives the flag, Lua still blocks the API writes.

## UI and handler mapping

Paths in this table are relative to
`content/trollnelves2/panorama/layout/custom_game/`. Current Lua custom events are
registered in `game/trollnelves2/scripts/vscripts/internal/trollnelves2.lua`.

| Layout/control | JS handler | Event and Lua path | Endpoint |
| --- | --- | --- | --- |
| `donate_shop/donate_shop.xml`: dynamic `BuyItemPanel` confirmations, both regular item and premium-pass dialog | `BuyItemFunction` | `BuyShopItem` → `Shop:BuyShopItem` | `buy/` |
| Same: dynamic `OpenChestButton` | `OpenChest` | `OpenChestAnimation` → `Shop:OpenChestAnimation` → `Shop:GetReward` → `Shop:BuyOpenChests` | `buy/` |
| Same: inventory `RecomItem` courier cards | `SelectCourier` | `SetDefaultPets` → `SelectPets:SetDefaultPets` → `Shop.GetVip` | API base |
| Same: effect cards | `SelectParticle` | `SetDefaultPart` → `wearables:SetDefaultPart` → `Shop.GetVip` | API base |
| Same: skin cards | `SelectSkin` | `SetDefaultSkin` → `wearables:SetDefaultSkin` → `Shop.GetVip` | API base |
| Same: label cards | `SelectLabel` | `SetDefaultLabel` → `wearables:SetDefaultLabel` → `Shop.GetVip` | API base |
| Same: tower/true-sight/high-true-sight/flag cards | `SelectTower` | `SetDefaultSkinTower` → `wearables:SetDefaultSkinTower` → `Shop.GetVip` | API base |
| Same: wisp cards | `SelectWisp` | `SetDefaultSkinWisp` → `wearables:SetDefaultSkinWisp` → `Shop.GetVip` | API base |
| `rewards/rewards.xml`: dynamic `RewardClaimButton` | `RecieveReward` | `EventRewards` → `Shop:EventRewards` | `postrewards/` |
| `battlepass/battlepass.xml`: dynamic free/premium `PanelLock` claim overlays | `GiveReward` | `EventBattlePass` → `Shop:EventBattlePass` | `battlepass/` |
| `statistics/statistics.xml`: `SettingButtonYes`/`SettingButtonNo` for FPS, mute, block | Anonymous callbacks in `CreateButtonSetting`, guarded at dispatch | `Statistics` → `Shop:Statistics` → `SetDefaultStats` → `Shop.GetVip` | API base |
| `spell_shop/spell_shop.xml`: dynamic upgrade control (`SpellPreviewPanelButtonUpgrade`) | `UpgradeSpell` | `event_upgrade_spell` → `game_spells_lib:event_upgrade_spell` → `Shop.GetSkill` | `buy/` |
| Dormant `spell_temple/spell_temple.xml`: upgrade control and purchase control (`SpellPreviewPanelButtonActivate`) | `UpgradeSpell`, `ActivateSpell` | `event_upgrade_spell` as above; dormant `event_buy_spell` has no active Lua listener | `buy/` if that legacy listener is restored |
| Dormant `old_files/old_xml/{particles,pets}.xml`: `DefaultButton` | `DefaultButton` in each matching legacy JS file | `SetDefaultPart` or `SetDefaultPets` → saved-default helper | API base |
| Native inventory redemption items (item KV `OnSpellStart`) | Engine cast; no Panorama custom event | Nine guarded `custom_abilities.lua` callbacks → `Shop.GetGem` or `Shop.GetVip` | `coint/` or API base |

Item and chest preview cards remain usable; their confirmation buttons are disabled.
The battle-pass purchase navigation still opens its readable preview. Cosmetics
whose cards save defaults are disabled. Sound previews/playback, panel tabs, close
buttons, statistics/leaderboards, quest information, owned-spell activation, voting,
resource transfers, building actions, and external browser links remain available.

The native redemption items are exactly:
`item_vip`, `item_event_desert`, `item_event_winter`, `item_event_helheim`,
`item_event_birthday`, `item_get_gem`, `item_get_gold`, `item_autumn`,
`item_winter_stress`, `item_winter_1`, `item_spring`, `item_summer`,
`item_ghosttown`, and `little_spider`. The existing inventory overlay update dims
and disables only slots currently containing these items and restores a slot when
its contents change. The existing `BuildingHelper:OrderFilter` rejects their
no-target casts before item cooldowns/consumption, covering hotkeys and engine
orders. Ordinary items, including `item_flicker`, remain unaffected.

Guarded native callbacks: `ItemGetGem`, `ItemGetGold`, `ItemEffect`, `ItemEvent`,
`ItemEventStresS`, `ItemEventDesert`, `ItemEventWinter`, `ItemEventHelheim`,
`ItemEventBirthday`.

Every other guarded Lua function is listed in the request inventory or UI mapping.
`Shop:Statistics` specially permits `check == 1`: this applies previously loaded
settings locally and deliberately does not persist them.

## Automatic writes and paths preserved

| Trigger | Write path blocked | Preserved behavior |
| --- | --- | --- |
| Match-ending branches in `events.lua` | `Stats.SubmitMatchData` → `Stats.Normal`/`Tournament1x1` → guarded `Stats.SendData` | Local game-end handling and winner selection still run |
| Clan match end | `Clanwars.SubmitMatchData` → guarded `Clanwars.SendData` and `Shop.GetGem` | Local clan match completion still runs |
| Match quest evaluation | `Stats.CheckDayQuest` → guarded `Shop.GetDayDone`, `GetXpBattlepass`, `GetGetGemChest` | Local evaluation and quest display remain |
| Lua exception or failed request | `Error_debug.ErrorCheck`/`printTryError`, HTTP failure callbacks → guarded `Error_debug.SendData` | Local traceback printing remains; failed READs cannot emit debug POSTs |
| Initialization/profile refresh | READ failures can lead to the debug path above | Profile, leaderboard, date/time, quest definition GETs remain |
| 15-second profile/leaderboard/time retries | No write retry found; any secondary error-report POST is blocked | Existing GET retry behavior remains |
| Quest reward callbacks scheduling a 15-second profile refresh | Originating reward POST is blocked | Successful normal-mode callback/refresh behavior unchanged |
| Reconnect/settings restoration via `Shop:SetStats` | No write: calls `Shop:Statistics(..., 1, ...)` | Local setting restoration remains, including hero-wait retry |
| JS spell cooldown timers | Actual upgrade/purchase handlers return before scheduling | Existing normal-mode cooldown behavior remains |

No independent API-writing auto-save, unload/close callback, periodic POST,
inventory synchronization POST, or active console/admin HTTP dispatcher was found.
Commented chat-command writes, clan UI events, random spell purchase Lua handler and
listener, and commented `RequestXp` are left inactive. The commented random-purchase
JS bodies are unchanged. No pure READ helper has a restricted guard. Local-only
cosmetic selection events remain callable separately; the combined UI actions that
also save defaults are blocked. Ordinary gameplay mutations are intentionally
outside the web-persistence restriction.

## Changed files

Lua paths relative to `game/trollnelves2/scripts/vscripts/`:

| File | Change |
| --- | --- |
| `settings.lua` | Predicate, boolean replication, native redemption item set |
| `stats.lua` | Guard match POST helper |
| `clanwars.lua` | Guard clan POST helper |
| `error_debug.lua` | Ensure settings helper is loaded; guard error-report POST |
| `donate_store/shop.lua` | Guard ten POST helpers and chest/settings entry points |
| `donate_store/wearables.lua` | Guard five saved cosmetic default handlers |
| `donate_store/selectpets.lua` | Guard saved pet default handler |
| `game_spells_lib.lua` | Guard upgrade before local inventory mutation |
| `custom_abilities.lua` | Guard nine native redemption callbacks |
| `libraries/buildinghelper.lua` | Block native redemption cast orders |

Panorama paths relative to `content/trollnelves2/panorama/layout/custom_game/`:

| File | Change |
| --- | --- |
| `custom_ui_manifest.xml` | Load shared helper before UI scripts |
| `scripts/restricted_client.js` (new) | Shared flag and targeted control disabling |
| `scripts/inventory_sell_overlay.js` | Update native redemption slots in existing refresh |
| `donate_shop/donate_shop.js` | Guard eight actions and disable purchase/chest/cosmetic controls |
| `rewards/rewards.js` | Guard daily claim and disable claim button |
| `battlepass/battlepass.js` | Guard pass claim and disable both claim overlay types |
| `statistics/statistics.js` | Guard and disable persistent settings toggles |
| `spell_shop/spell_shop.js` | Guard and disable upgrade |
| `spell_temple/spell_temple.js` | Guard and disable legacy purchase/upgrade |
| `old_files/old_js/particles.js` | Guard and disable legacy default button |
| `old_files/old_js/pets.js` | Guard and disable legacy default button |

New repository files:
`tests/restricted_client.test.js`, `tests/restricted_client_test.py`, and this audit.

## Verification results

Passed:

- JS syntax checks for every changed/new JS file.
- Real handler execution with mocked Panorama: restricted direct calls send no
  custom write event and schedule no cooldown work; 21 normal-mode event/payload
  comparisons match the original `HEAD` implementations.
- Dynamic shop/chest confirmations, inventory defaults, daily/free/premium claims,
  settings toggles, and upgrade/purchase controls disable correctly; item/chest
  previews stay enabled. Late flag delivery, boolean/numeric flags, destroyed
  panels, and restoration of already-disabled controls are covered.
- LuaJIT compilation of all ten changed Lua files.
- Real Lua helper execution: all 13 POST sites emit no request in restricted mode.
  Normal-mode method, URL, headers, content type, and encoded payload match `HEAD`.
- All eight active GET sites still execute with unchanged requests in restricted
  mode; failed READ logging sends no POST; existing date/time retries still run.
- Twenty higher-level Lua entry points return before dependent game objects are
  accessed; saved settings with `check == 1` still apply locally.
- Native redemption names exactly match parsed item KV callbacks. Their cast
  orders are blocked in restricted mode; normal mode and unrelated items still
  delegate to the existing order filter.
- `git diff --check` passes.

Run from the repository root:

```text
node tests/restricted_client.test.js
python tests/restricted_client_test.py
```

The Python test requires `lupa` with `lupa.luajit21`. Tests use mocked HTTP and make
no API requests. During implementation, lupa was installed in a temporary test
directory, not added to the game or its runtime dependencies. Both suites compare
against repository `HEAD`, which must be the pre-change revision for those baseline
comparisons.

Normal-mode compatibility is supported by the request/event comparisons and the
additive guards; routes, request bodies, callback code, game rules and API
authorization were not changed. No Dota engine session or live API was run here, so
live UI rendering, gameplay and server responses have not been claimed as tested.

Remaining in-engine checks:

1. Start a non-dedicated session; verify the replicated flag, disabled/dim write
   controls, readable previews, and native redemption slots/hotkeys. Reopen panels
   and reconnect to exercise UI reconstruction and net-table delivery.
2. Monitor HTTP creation with test instrumentation while invoking write actions,
   ending normal/tournament/clan matches and completing quests: no POST should be
   created. Check READ data and retries under the existing cheat-mode conditions.
3. Repeat with a normal dedicated key: normal actions, item casts, payloads,
   callbacks and game completion should behave as before.
