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
            GetTableValue: (_, key) => key === 'restricted_client' ? state : key === 'settings' ? { enable_perk_upgrades: true } : { 0: { 0: 1000, 1: 1000 }, cost: 10 },
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
    if (file === 'spell_shop/spell_shop.js' && !original) vm.runInContext(declaration(text, 'ArePerkUpgradesEnabled'), env.context);
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

// Native sell-overlay refresh only affects sell markers, never slot activation.
for (const restricted of [true, false]) {
    const e = environment(restricted);
    load(e, 'scripts/inventory_sell_overlay.js', ['UpdateSellOverlays']);
    const slots = Array.from({ length: 9 }, () => e.panel());
    Object.assign(e.context, { cachedOverlays: {},
        GetDotaHud: () => ({ FindChildTraverse: id => slots[Number(id.split('_').pop())] }),
        Entities: { GetItemInSlot: () => 123 } });
    e.context.Players.GetLocalPlayerPortraitUnit = () => 1;
    e.context.UpdateSellOverlays();
    slots.forEach(slot => {
        assert.equal(slot.enabled, true);
        assert.equal(slot.style.opacity, undefined);
        assert.equal(slot.style.saturation, undefined);
    });
}

const cases = [
    ['donate_shop/donate_shop.js', 'BuyItemFunction', () => [[null, 601, 'gold', 10, 'skin', 'skin_1']]],
    ['donate_shop/donate_shop.js', 'OpenChest', () => [[null, 590]]],
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
// Owned cosmetic cards keep local events and active-state rendering in both modes.
const cosmetics = ['pet_1', 'particle_1', 'skin_1', 'skin_wisp_1', 'tower_1', 'true_sight_tower_1', 'high_true_sight_tower_1', 'flag_1', 'label_1'].map(type => [type, 121]);
cosmetics.push(['skin_wolf', 620], ['skin_bear', 673]);
const inventoryFunctions = ['CreateItem', 'SetItemInventory', 'IsItemActivated', 'GetItemActiveType',
    'SelectCourier', 'SelectParticle', 'SelectSkin', 'SelectLabel', 'SelectWisp', 'SelectTower', 'UpdateShop'];
for (const restricted of [true, false, undefined]) {
    for (const [type, id] of cosmetics) {
        const inventory = environment(restricted), original = environment(false);
        const item = [null, id, 'gold', 10, type, type];
        for (const [e, before] of [[inventory, false], [original, true]]) {
            load(e, 'donate_shop/donate_shop.js', inventoryFunctions, before);
            Object.assign(e.context, { IsItemChest: () => false, PlayerHasItem: () => true,
                ItemTooltipShow() {}, GetShortItemName: () => type, SetMainCurrency() {}, player_active_items: {} });
        }
        const slot = inventory.context.GetItemActiveType(item);
        const selected = slot === 'effect' ? id - 100 : id;
        let rebuilds = 0;
        inventory.context.InitInventory = () => rebuilds++;
        for (const active of [false, true]) {
            const cards = [];
            for (const e of [inventory, original]) {
                e.context.player_active_items = active ? { [slot]: selected } : {};
                const parent = e.panel();
                e.context.CreateItem(parent, [item], 0, true);
                const card = parent.children[0];
                assert.equal(card.enabled, true, type);
                assert.notEqual(card.style.opacity, '0.35', type);
                assert.equal(card.BHasClass('DeactivateItem'), active, type);
                const label = card.children.find(p => p.id === 'BuyItemPanel').children[0].children[0];
                assert.equal(label.text, active ? '#SpellShop_Deactivate' : '#SpellShop_Activate', type);
                cards.push(card);
            }
            if (restricted === undefined) inventory.setState(true); // Late replication must not dim cards.
            assert.equal(cards[0].enabled, true, type);
            inventory.events.length = original.events.length = 0;
            cards.forEach(card => card.handlers.onactivate());
            const expected = restricted === false ? original.events : original.events.filter(([name]) => !name.startsWith('SetDefault'));
            assert.deepEqual(inventory.events, expected, type);
            assert.equal(inventory.events[0][1].offp, active, type);
            assert.equal(inventory.events.length, restricted === false ? 2 : 1, type);
            // Deliver the authoritative Lua active-state update through the real UI listener.
            inventory.context.UpdateShop('Shop_active', 0, active ? {} : { [slot]: selected });
            assert.equal(inventory.context.IsItemActivated(slot, selected), !active, type);
        }
        assert.equal(rebuilds, 2);
        assert.equal(inventory.schedules.length, 0);
        // Ownership filtering remains in place.
        inventory.context.PlayerHasItem = () => false;
        const parent = inventory.panel();
        inventory.context.CreateItem(parent, [item], 0, true);
        assert.equal(parent.children.length, 0);
    }
}

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
console.log('PASS: 11 inventory cosmetic cases activate/deactivate, render active state, handle late restriction, retain ownership filtering, and match normal-mode HEAD events.');

// Perk mode: real preview, selection and upgrade handlers, with saved levels intact.
for (const enabled of [false, true, 0, 1, undefined]) {
    for (const saved of [1, 2, 3]) {
        const run = (original = false) => {
            const e = environment(false);
            const info = {1:'elf_spell_gold', 2:'elf_spell_gold', 3:'modifier_elf_spell_gold',
                4:{1:'gold_description'}, 5:{1:{1:10,2:15,3:20}}, 6:'0', 7:'1'};
            const shop = {0:{1:100000},12:{1:{1:info[1],2:saved}},18:{0:{1:10000}}};
            let mode = enabled;
            e.context.CustomNetTables.GetTableValue = (table, key) => {
                if (table === 'Shop') return key === 'restricted_client' ? {isRestrictedClient:false} : shop;
                if (key === 'settings') return mode === undefined ? undefined : {enable_perk_upgrades:mode};
                if (key === 'spell_list') return {1:info};
                if (key === 'spell_active') return {0:{1:info[1]}};
            };
            const create = e.context.$.CreatePanel;
            e.context.$.CreatePanel = (...args) => {
                const p = create(...args); p.visible = true;
                p.FindChildTraverse = function(id) {
                    for (const child of this.children) {
                        if (child.id === id) return child;
                        const found = child.FindChildTraverse(id); if (found) return found;
                    }
                    return null;
                };
                return p;
            };
            e.context.Players.GetPlayerSelectedHero = () => 'npc_dota_hero_treant';
            e.context.activate_cooldown = false;
            e.context.SPELLS_TEXTURE = {};
            e.context.CURRENT_SPELL_SELECTED = info;
            load(e, 'spell_shop/spell_shop.js', ['UpdatePreviewSpellInf','GetPlayerSpellLevel',
                'GetSelectedPlayerSpellLevel','GetSpellTexture','GetSpellCost','PlayerHasSpell',
                'IsSpellActivate','SetUpgradeSpell','UpgradeSpell','SetActivateSpell','ActivateSpell',
                'UpdateSpellsLibTable'], original);
            e.context.UpdateActivatedSpellVisual = () => {};
            e.context.UpdateVisualSelectedSpells = () => {};
            e.context.UpdateHasSpells = () => {};
            e.context.UpdatePreviewSpellInf(info);
            return {...e, info, shop, setMode(value){mode=value; e.context.UpdateSpellsLibTable('game_spells_lib','settings',{});}};
        };
        const e = run(), isEnabled = enabled === true || enabled === 1;
        const columns = e.panels.filter(p => /^SpellColumnBonus_\d$/.test(p.id));
        assert.equal(columns.length, isEnabled ? 3 : 1);
        assert.equal(columns.find(p => p.BHasClass('IsActiveColumn')).id, 'SpellColumnBonus_' + (isEnabled ? saved : 1));
        assert.deepEqual(columns.map(p => p.children.filter(c => c.BHasClass('SpellPreviewLevelLabelValue')).map(c => c.text)), isEnabled ? [[10],[15],[20]] : [[10]]);
        const button = e.panels.find(p => p.BHasClass('SpellPreviewPanelButtonUpgrade'));
        assert.equal(button.visible, isEnabled && saved < 3);
        assert.equal(e.context.GetSelectedPlayerSpellLevel(e.info[1],0), isEnabled ? saved : 1);
        e.context.UpgradeSpell(e.info);
        assert.equal(e.events.length, isEnabled && saved < 3 ? 1 : 0);
        assert.equal(e.schedules.length, isEnabled && saved < 3 ? 1 : 0);
        e.context.ActivateSpell(e.info);
        assert.equal(e.events.at(-1)[0], 'event_set_activate_spell');
        assert.equal(e.shop[12][1][2], saved);
        if (isEnabled) {
            const before = run(true);
            const snapshot = p => ({id:p.id, classes:[...p.classes], text:p.text, style:p.style, visible:p.visible});
            assert.deepEqual(e.panels.map(snapshot), before.panels.map(snapshot));
            before.context.UpgradeSpell(before.info); before.context.ActivateSpell(before.info);
            assert.deepEqual(e.events, before.events);
        } else {
            assert.deepEqual(columns[0].style, {});
            columns[0].children.forEach(child => assert.deepEqual(child.style, {}));
            const bottom = e.panels.find(p => p.BHasClass('SpellPreviewPanelButtonActivate'));
            assert.equal(bottom.style.visibility, 'collapse');
        }
        const count = e.panels.length;
        e.setMode(!isEnabled);
        assert.equal(e.panels.slice(count).filter(p=>/^SpellColumnBonus_\d$/.test(p.id)).length, isEnabled ? 1 : 3);
    }
}
console.log('PASS: perk modes, LVL 1 values/highlight, hidden Upgrade, direct JS guard, selection, saved data, late mode delivery, normal preview/event equality.');
