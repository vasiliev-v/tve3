// Run with: node tests/restricted_client.test.js
// Tests real Panorama functions with mocked panels/events; never contacts the API.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const cp = require('node:child_process');
const root = path.resolve(__dirname, '..');
const base = 'content/trollnelves2/panorama/layout/custom_game/';
function source(file, original = false) {
    const name = base + file;
    return original ? cp.execFileSync('git', ['-c', 'safe.directory=' + root.replaceAll('\\', '/'), 'show', 'HEAD:' + name], { cwd: root, encoding: 'utf8' }) : fs.readFileSync(path.join(root, name), 'utf8');
}
// Let the JS parser identify the closing brace, including nested strings/comments.
function declaration(text, name) {
    const start = text.search(new RegExp('function ' + name + '\\('));
    assert(start >= 0, name);
    for (let end = text.indexOf('}', start); end >= 0; end = text.indexOf('}', end + 1)) {
        const candidate = text.slice(start, end + 1);
        try { new vm.Script('(' + candidate + ')'); return candidate; } catch (_) {}
    }
    throw Error('Cannot parse ' + name);
}
function environment(restricted) {
    let state = restricted === undefined ? undefined : { isRestrictedClient: restricted };
    const listeners = [], panels = [], events = [], schedules = [], config = {};
    function panel(id = '') {
        const p = { id, enabled: true, style: {}, valid: true, children: [], handlers: {}, classes: new Set(),
            IsValid() { return this.valid; }, AddClass(c) { this.classes.add(c); }, RemoveClass(c) { this.classes.delete(c); },
            SetHasClass(c, yes) { yes ? this.AddClass(c) : this.RemoveClass(c); },
            SetPanelEvent(n, cb) { this.handlers[n] = cb; }, GetChild(i) { return this.children[i]; },
            FindChildTraverse(id) { return this.children.find(c => c.id === id) || panel(id); },
            RemoveAndDeleteChildren() { this.children = []; }, BHasClass(c) { return this.classes.has(c); }
        };
        panels.push(p); return p;
    }
    const roots = {};
    function $(id) { return roots[id] || (roots[id] = panel(id)); }
    $.CreatePanel = (_, parent, id) => { const p = panel(id); parent.children.push(p); return p; };
    $.Localize = s => s;
    $.Schedule = (_, cb) => schedules.push(cb);
    const context = vm.createContext({ $, console, GameUI: { CustomUIConfig: () => config },
        CustomNetTables: {
            GetTableValue: (_, key) => key === 'restricted_client' ? state : { 0: { 0: 1000, 1: 1000 }, cost: 10 },
            SubscribeNetTableListener: (_, cb) => listeners.push(cb)
        },
        GameEvents: { SendCustomGameEventToServer: (name, data) => events.push([name, JSON.parse(JSON.stringify(data))]) },
        Players: { GetLocalPlayer: () => 0 }, Game: { EmitSound() {} },
        player_table: [[1000, 1000]], buy_cooldown: false, active_shop: 0,
        GetPlayerSpellLevel: () => 1, GetSpellCost: () => 10, CheckBuyAllSpells: () => false,
        ShopError: () => { throw Error('Unexpected shop error'); }
    });
    vm.runInContext(source('scripts/restricted_client.js'), context);
    return { context, config, panel, panels, events, schedules, $, setState(value) {
        state = { isRestrictedClient: value }; listeners.forEach(cb => cb('Shop', 'restricted_client', state));
    } };
}
function load(env, file, names, original = false) {
    const text = source(file, original);
    names.forEach(name => vm.runInContext(declaration(text, name), env.context));
}

// Every edited JS file must parse, including dormant layouts.
for (const file of ['scripts/restricted_client.js', 'scripts/inventory_sell_overlay.js', 'donate_shop/donate_shop.js', 'rewards/rewards.js', 'battlepass/battlepass.js', 'statistics/statistics.js', 'spell_shop/spell_shop.js', 'spell_temple/spell_temple.js', 'old_files/old_js/particles.js', 'old_files/old_js/pets.js']) new vm.Script(source(file), { filename: file });

const env = environment();
const write = env.panel(), previouslyDisabled = env.panel(), read = env.panel();
previouslyDisabled.enabled = false;
env.config.RegisterWriteControl(write);
env.config.RegisterWriteControl(previouslyDisabled);
assert.equal(write.enabled, true);
env.setState(1); // Lua booleans may arrive as numbers.
assert.equal(write.enabled, false);
assert.equal(write.style.opacity, '0.35');
assert.equal(read.enabled, true);
const dynamic = env.panel(); env.config.RegisterWriteControl(dynamic);
assert.equal(dynamic.enabled, false);
dynamic.valid = false;
env.setState(0);
assert.equal(write.enabled, true);
assert.equal(write.style.opacity, undefined);
assert.equal(previouslyDisabled.enabled, false);
env.setState(true); assert.equal(write.enabled, false);
env.setState(false); assert.equal(write.enabled, true);
// A native slot is restored when a read-only/local item replaces a write item.
env.config.SetWriteControlRestricted(read, true);
env.config.SetWriteControlRestricted(read, false);
assert.equal(read.enabled, true);

const cases = [
    ['donate_shop/donate_shop.js', 'BuyItemFunction', () => [[null, 601, 'gold', 10, 'skin', 'skin_1']]],
    ['donate_shop/donate_shop.js', 'OpenChest', () => [[null, 590]]],
    ...['SelectCourier', 'SelectParticle', 'SelectSkin', 'SelectLabel', 'SelectWisp'].flatMap(name => [false, true].map(active => ['donate_shop/donate_shop.js', name, () => [121, active]])),
    ...[false, true].map(active => ['donate_shop/donate_shop.js', 'SelectTower', () => [[null, 601, null, null, null, 'tower'], active]]),
    ['rewards/rewards.js', 'RecieveReward', e => { const claim = e.panel(), reward = e.panel(); claim.children.push(e.panel()); return [claim, reward, 1, 25]; }],
    ['battlepass/battlepass.js', 'GiveReward', e => [1001, e.panel(), e.panel()]],
    ['spell_shop/spell_shop.js', 'UpgradeSpell', () => [[null, 'elf_spell_test']]],
    ['spell_temple/spell_temple.js', 'UpgradeSpell', () => [[null, 'elf_spell_test']]],
    ['spell_temple/spell_temple.js', 'ActivateSpell', () => [[null, 'elf_spell_test']]],
    ...['particles', 'pets'].map(name => ['old_files/old_js/' + name + '.js', 'DefaultButton', e => { e.context.selectedpart = null; return []; }])
];
for (const [file, name, args] of cases) {
    const blocked = environment(true); load(blocked, file, [name]);
    blocked.context[name](...args(blocked));
    assert.equal(blocked.events.length, 0, name + ' emitted event');
    assert.equal(blocked.schedules.length, 0, name + ' scheduled work');
    const current = environment(false), original = environment(false);
    for (const [e, before] of [[current, false], [original, true]]) { load(e, file, [name], before); e.context[name](...args(e)); }
    assert(current.events.length > 0, name + ' normal event missing');
    assert.deepEqual(current.events, original.events, name + ' normal payload changed');
}

// Dynamically built settings controls: disabled visually, guarded even if invoked directly.
const settings = environment(false);
load(settings, 'statistics/statistics.js', ['CreateButtonSetting']);
settings.context.CreateButtonSetting({ function_name: 'fps', localize: 'fps', info_in_table: 4 }, null, 'fps');
const buttons = settings.panels.filter(p => p.handlers.onactivate);
assert.equal(buttons.length, 2);
buttons.forEach(p => p.handlers.onactivate()); assert.equal(settings.events.length, 2);
settings.setState(true);
buttons.forEach(p => { assert.equal(p.enabled, false); p.handlers.onactivate(); });
assert.equal(settings.events.length, 2);

for (const [file, builder] of [['spell_shop/spell_shop.js', 'SetUpgradeSpell'], ['spell_temple/spell_temple.js', 'SetUpgradeSpell'], ['spell_temple/spell_temple.js', 'SetActivateSpell']]) {
    const e = environment(true); load(e, file, [builder]); const p = e.panel(); e.context[builder](p, []); assert.equal(p.enabled, false);
}
const inventory = environment(true);
load(inventory, 'donate_shop/donate_shop.js', ['SetItemInventory']);
for (const type of ['pet_1', 'particle_1', 'skin_1', 'skin_wisp_1', 'tower_1', 'true_sight_tower_1', 'high_true_sight_tower_1', 'flag_1', 'label_1']) {
    const p = inventory.panel(); inventory.context.SetItemInventory(p, [null, 1, null, null, null, type], false); assert.equal(p.enabled, false, type);
}
const nonWrite = inventory.panel(); inventory.context.SetItemInventory(nonWrite, [null, 1, null, null, null, 'sounds'], false); assert.equal(nonWrite.enabled, true);

// Item/chest previews stay usable; only their confirmation controls are disabled.
const shop = environment(true);
load(shop, 'donate_shop/donate_shop.js', ['SetItemBuyFunction', 'SetOpenChestPanel', 'BuyItemFunction', 'OpenChest']);
Object.assign(shop.context, { Items_ALL: {}, GetChestInfo: () => [null, {}, {}],
    CreateItemCurrencyPreview() {}, RecreateRandomItemsList() {}, CloseItemInfo() {} });
for (const [builder, buttonID] of [['SetItemBuyFunction', 'BuyItemPanel'], ['SetOpenChestPanel', 'OpenChestButton']]) {
    const preview = shop.panel();
    shop.context[builder](preview, [null, 601, 'gold', 10, 'skin_1', 'skin_1']);
    assert.equal(preview.enabled, true);
    preview.handlers.onactivate();
    const button = shop.panels.find(p => p.id === buttonID);
    assert(button); assert.equal(button.enabled, false);
    button.handlers.onactivate(); assert.equal(shop.events.length, 0);
}
const daily = environment(true);
load(daily, 'rewards/rewards.js', ['CreateReward', 'RecieveReward']);
daily.context.player_table = [0, 1, 1];
daily.context.CreateReward(1, 1, ['1', 'reward_gems', '25', 'reward_gems', '1'], 0);
const claim = daily.panels.find(p => p.id === 'RewardClaimButton');
assert.equal(claim.enabled, false); claim.handlers.onactivate(); assert.equal(daily.events.length, 0);
const bp = environment(true);
load(bp, 'battlepass/battlepass.js', ['CreateFreeReward', 'CreateDonateReward', 'GiveReward']);
Object.assign(bp.context, { player_bp_info: [0, {}, { 0: 'premium' }],
    free_rewards: { 1: { 1: '1', 3: 'gems', 4: '10', 5: '1001' } },
    donate_rewards: { 1: { 1: '1', 3: 'gems', 4: '10', 5: '1' } } });
bp.context.CreateFreeReward(bp.panel(), 1, 1);
bp.context.CreateDonateReward(bp.panel(), 1, 1);
const locks = bp.panels.filter(p => p.id === 'PanelLock');
assert.equal(locks.length, 2);
locks.forEach(p => { assert.equal(p.enabled, false); p.handlers.onactivate(); });
assert.equal(bp.events.length, 0);
console.log('PASS: JS syntax, late state delivery, dynamic controls, direct handlers, and ' + cases.length + ' normal-mode event/payload comparisons.');
