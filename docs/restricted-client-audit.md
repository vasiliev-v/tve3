# Restricted client mode

Restricted mode is enabled only when Lua's `dedicatedServerKey` equals
`Invalid_NotOnDedicatedServer`. This is a UX/network-traffic guard, not an
authorization boundary. The ASP.NET Core API remains responsible for authorization.

## Investigation and request inventory

The investigation covered both junction-backed source trees, including current and
legacy Panorama scripts/layouts, Lua helpers, listeners, timers, chat/console paths,
and item KV callbacks. The pre-edit findings and proposed changes were reported in
the task before editing. `RequestXp` is commented out.

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
  `isRestrictedClient`. No raw key is exposed.
- `scripts/restricted_client.js`, loaded first in the manifest, supplies
  `GameUI.CustomUIConfig().IsRestrictedClient()` and control registration. It accepts
  replicated boolean or numeric flags and updates already-created panels when the
  flag arrives. New panels use the current flag immediately.
- Registered write controls have `enabled=false`, opacity `0.35`, and saturation `0`.
  Normal mode does not change their existing enabled/style state. If the replicated
  flag changes back, the helper restores the state it changed, including controls
  that were already disabled. Deleted panels are removed from its registry.
- JS write-action guards run before optimistic UI changes or cooldown scheduling.
  Inventory cosmetics always send local selection events; only their separate
  saved-default events are guarded. Lua write helpers return before creating HTTP requests or
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
The battle-pass purchase navigation still opens its readable preview. Owned cosmetic
cards remain enabled for local equip/unequip; their saved-default events are skipped
in restricted mode. Sound previews/playback, panel tabs, close
buttons, statistics/leaderboards, quest information, owned-spell activation, voting,
resource transfers, building actions, and external browser links remain available.

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
cosmetic selection events remain callable through Inventory; only the separate
default-save dispatch is blocked. Ordinary gameplay mutations are intentionally
outside the web-persistence restriction.

## Changed files

Lua paths relative to `game/trollnelves2/scripts/vscripts/`:

| File | Change |
| --- | --- |
| `settings.lua` | Predicate and boolean replication |
| `stats.lua` | Guard match POST helper |
| `clanwars.lua` | Guard clan POST helper |
| `error_debug.lua` | Ensure settings helper is loaded; guard error-report POST |
| `donate_store/shop.lua` | Guard ten POST helpers and chest/settings entry points |
| `donate_store/wearables.lua` | Guard five saved cosmetic default handlers |
| `donate_store/selectpets.lua` | Guard saved pet default handler |
| `game_spells_lib.lua` | Guard upgrade before local inventory mutation |
| `custom_abilities.lua` | Guard nine native redemption callbacks |

Panorama paths relative to `content/trollnelves2/panorama/layout/custom_game/`:

| File | Change |
| --- | --- |
| `custom_ui_manifest.xml` | Load shared helper before UI scripts |
| `scripts/restricted_client.js` (new) | Shared flag and targeted control disabling |
| `donate_shop/donate_shop.js` | Guard purchases/chest opening and cosmetic default-save dispatches; disable only purchase/chest confirmation controls |
| `rewards/rewards.js` | Guard daily claim and disable claim button |
| `battlepass/battlepass.js` | Guard pass claim and disable both claim overlay types |
| `statistics/statistics.js` | Guard and disable persistent settings toggles |
| `spell_shop/spell_shop.js` | Guard and disable upgrade |
| `spell_temple/spell_temple.js` | Guard and disable legacy purchase/upgrade |
| `old_files/old_js/particles.js` | Guard and disable legacy default button |
| `old_files/old_js/pets.js` | Guard and disable legacy default button |

New repository files:
`tests/restricted_client.test.js`, `tests/restricted_client_test.py`, and this audit.

## Inventory correction: local equip without persistence

All cosmetic Inventory cards are **local + persisted default** in normal mode,
with separate events for each responsibility:

| Category | JS handler | Local event / Lua handler | Persistence event / Lua handler |
| --- | --- | --- | --- |
| Pets | `SelectCourier` | `SelectPets` / `SelectPets:SelectPets` | `SetDefaultPets` / `SelectPets:SetDefaultPets` |
| Effects | `SelectParticle` | `SelectPart` / `wearables:SelectPart` | `SetDefaultPart` / `wearables:SetDefaultPart` |
| Player skins, including wolf/bear | `SelectSkin` | `SelectSkin` / `wearables:SelectSkin` | `SetDefaultSkin` / `wearables:SetDefaultSkin` |
| Tower, true-sight tower, high true-sight tower, flag | `SelectTower` | `SelectSkinTower` / `wearables:SelectSkinTower` | `SetDefaultSkinTower` / `wearables:SetDefaultSkinTower` |
| WISP skins | `SelectWisp` | `SelectSkinWisp` / `wearables:SelectSkinWisp` | `SetDefaultSkinWisp` / `wearables:SetDefaultSkinWisp` |
| Tag | `SelectLabel` | `SelectLabel` / `wearables:SelectLabel` | `SetDefaultLabel` / `wearables:SetDefaultLabel` |

`CreateItem` filters ownership and `SetItemInventory` binds the cosmetic card.
The local Lua handlers apply the existing pet/effect/model/label logic, maintain
`GameRules.SkinTower`, and publish `Shop_active`. `UpdateShop` receives that state,
rebuilds Inventory, and displays Activate/Deactivate using `IsItemActivated`.
This indicates current-match activity, not a successful default save.

The smallest production correction is confined to `donate_shop.js`: remove cosmetic
card write-control registration and move the six handler-wide restrictions onto
the twelve `SetDefault...` dispatches. Restricted clicks still send `Select...`.
The existing Lua `SetDefault...` guards skip persistence and saved-default counters;
`Shop.GetVip` also guards HTTP creation, including before JS receives the flag.
No Lua production changes are necessary. Normal events, ordering, payloads, HTTP
endpoints and response handling remain unchanged.

Chests have no activation/default selection. Their preview is purely local;
opening is a persistent consume/reward action through `OpenChest` →
`OpenChestAnimation` → `Shop:GetReward` → `Shop:BuyOpenChests`. Its confirmation
and write path remain blocked. The seven Inventory tabs are fully covered above;
sounds appear in Shop, with no separate Inventory selection tab.

Files changed for this correction:

- `content/trollnelves2/panorama/layout/custom_game/donate_shop/donate_shop.js`
- `tests/restricted_client.test.js`
- `tests/restricted_client_test.py`
- `docs/restricted-client-audit.md`

Verification: both suites pass. JS covers 11 cosmetic cases in normal, restricted,
and late-flag modes, both click directions, enabled visuals, active-state rendering,
the net-table listener, ownership filtering, and normal event equality against HEAD.
Lua executes the real selection/default handlers for the same 11 cases with mocked
engine application helpers: equip/unequip publishes active state, restricted mode
creates no HTTP or default counters, and normal default requests match HEAD.
Existing coverage still verifies all 13 blocked writes, eight active GET sites,
purchase/chest/reward controls, settings, upgrades and native redemption guards.
No live Dota session or API was run; actual model/particle rendering and engine
transport remain in-engine checks, not claims made by these mocked tests.

## Drop restriction

`drop.lua` returns immediately for the exact key
`Invalid_NotOnDedicatedServer` at each independently callable drop entry point:

- `drop:RollItemDrop(unit)`: called by `events.lua`, before rolls, limit changes
  or scheduling `RandomDropLoot`.
- `RandomDropLoot(item_name)`: before calling the shared `DropLootByRules` utility.
- `TimerRandomDrop(event)` and `TimerRandomDropWinter(event)`: ability callbacks
  that independently create items; guarded before scheduling their timers.

These independent paths require entry guards; they do not all pass through one
drop function. The shared utility, drop probabilities, item pools, normal timer
behavior and cleanup logic are unchanged. Native inventory slot activation and
order-filter delegation remain available in both modes. Separate purchase,
default-save, reward and API guards remain in effect.

Verification passes with mocked engine objects: all four entry points produce no
side effects for the exact sentinel, and other keys (including an empty string
and a sentinel with a suffix) match HEAD for drops, timers and limit changes.
Native sell-overlay refresh leaves all slots enabled and undimmed; cast orders
reach the existing order filter in both modes. The Inventory cosmetic regression
suite still passes, as do the existing HTTP protection checks. Live Dota rendering
and drops have not been exercised.

## Original restricted-client verification results

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
- `git diff --check` passes.

The inventory-specific blocked-button expectations above were superseded by the
correction below. Run the current suites from the repository root:

```text
node tests/restricted_client.test.js
python tests/restricted_client_test.py
```

The Python test requires `lupa` with `lupa.luajit21`. Tests use mocked HTTP and make
no API requests. During implementation, lupa was installed in a temporary test
directory, not added to the game or its runtime dependencies. Both suites compare
normal-mode requests/events against repository `HEAD`.

Normal-mode compatibility is supported by the request/event comparisons and the
additive guards; routes, request bodies, callback code, game rules and API
authorization were not changed. No Dota engine session or live API was run here, so
live UI rendering, gameplay and server responses have not been claimed as tested.

Remaining in-engine checks:

1. Start a non-dedicated session; verify the replicated flag, disabled/dim write
   controls and readable previews. Reopen panels
   and reconnect to exercise UI reconstruction and net-table delivery.
2. Monitor HTTP creation with test instrumentation while invoking write actions,
   ending normal/tournament/clan matches and completing quests: no POST should be
   created. Check READ data and retries under the existing cheat-mode conditions.
3. Repeat with a normal dedicated key: normal actions, item casts, payloads,
   callbacks and game completion should behave as before.
