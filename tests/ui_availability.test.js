// node tests/ui_availability.test.js -- real Panorama scripts, mocked engine/UI.
const assert = require('node:assert/strict');
const fs = require('node:fs');
const vm = require('node:vm');
const cp = require('node:child_process');
const path = require('node:path');
const root = path.resolve(__dirname, '..');
const base = 'content/trollnelves2/panorama/layout/custom_game/';
function source(file, original = false) {
    return original ? cp.execFileSync('git', ['-c', 'safe.directory=' + root.replaceAll('\\', '/'), 'show', 'HEAD:' + base + file], {cwd:root, encoding:'utf8'}) : fs.readFileSync(path.join(root, base, file), 'utf8');
}
function environment(file, restricted, shop, original = false, map = 'classic') {
    const state = {restricted_client: restricted === undefined ? undefined : {isRestrictedClient:restricted}, 0:shop, bpday:{}};
    const listeners = [], events = {}, timers = new Map(), panels = [], calls = [];
    let timerId = 0;
    function panel(id = '') {
        const p = {id, children:[], classes:new Set(), handlers:{}, style:{}, visible:true,
            IsValid:()=>true, AddClass(c){this.classes.add(c)}, RemoveClass(c){this.classes.delete(c)},
            SetHasClass(c,on){on?this.AddClass(c):this.RemoveClass(c)}, BHasClass(c){return this.classes.has(c)},
            SetPanelEvent(n,f){this.handlers[n]=f}, RemoveAndDeleteChildren(){this.children=[]}, DeleteAsync(){this.visible=false},
            FindChildTraverse(id){for(const c of this.children){if(c.id===id)return c;const found=c.FindChildTraverse(id);if(found)return found}return null},
            FindChildrenWithClassTraverse(c){return panels.filter(p=>p.classes.has(c))}};
        panels.push(p); return p;
    }
    const roots = {}, contextRoot = panel();
    for (const id of ['QuestMain','PanelShadow','QuestPanelSwap','QuestsPanel','TopMenuCustom']) roots['#'+id]=panel(id);
    contextRoot.children.push(roots['#QuestMain']);
    roots['#QuestMain'].children.push(roots['#PanelShadow'],roots['#QuestPanelSwap']);
    roots['#QuestPanelSwap'].children.push(roots['#QuestsPanel']);
    const $ = id => roots[id];
    $.GetContextPanel=()=>contextRoot;
    $.CreatePanel=(_,parent,id)=>{const p=panel(id);parent.children.push(p);return p};
    $.Localize=x=>x;
    $.Schedule=(_,fn)=>{timers.set(++timerId,fn);return timerId};
    $.CancelScheduled=id=>timers.delete(id);
    const config={OpenStoreGlobal:()=>calls.push('store')};
    const ctx=vm.createContext({$,console,GameUI:{CustomUIConfig:()=>config},Players:{GetLocalPlayer:()=>0},
        Game:{GetMapInfo:()=>({map_display_name:map})},GameEvents:{SubscribeProtected:(n,f)=>events[n]=f},
        CustomNetTables:{GetTableValue:(_,key)=>state[key],SubscribeNetTableListener:(_,fn)=>listeners.push(fn)}});
    vm.runInContext(source('scripts/restricted_client.js'),ctx);
    vm.runInContext(source(file,original),ctx);
    return {ctx,panels,roots,events,timers,calls,state,
        publish(key,value){state[key]=value;listeners.forEach(fn=>fn('Shop',key,value))},
        flush(){const pending=[...timers.values()];timers.clear();pending.forEach(fn=>fn())}};
}
function profile(coins=0,gems=0,inventory={},chests={}) {
    return {0:{0:coins,1:gems},1:inventory,4:chests,10:{1:{}},15:{0:'none'}};
}
const scenarios = [
    [false,profile(),false], [false,profile(1),true], [false,profile(0,1),true],
    [false,profile(0,0,{601:'601'}),true], [false,profile(1,1,{601:'601'}),true],
    [true,profile(),false], [true,profile(0,0,{601:'601'}),true],
    [false,profile(),false],
];
for(const [restricted,shop,available] of scenarios){
    const top=environment('top_menu/top_menu.js',restricted,shop);
    const store=top.panels.find(p=>p.classes.has('ButtonStore'));
    assert.equal(store.visible,available);
    if(available){store.handlers.onactivate();assert.deepEqual(top.calls,['store'])}
    const daily=environment('day_quest/day_quest.js',restricted,shop);
    assert.equal(daily.roots['#QuestMain'].visible,!restricted);
    assert.equal(daily.timers.size,restricted?0:1);
    if(restricted){daily.ctx.UpdateQuestAfter();daily.ctx.RebuildQuests();daily.publish('0',shop);assert.equal(daily.timers.size,0)}
    else {daily.flush();assert(daily.roots['#QuestsPanel'].children.length>0)}
}
// Async load, removal and sparse owned-item dictionaries, independent of restriction.
for(const restricted of [true,false]){
    const e=environment('top_menu/top_menu.js',restricted,undefined);
    const store=e.panels.find(p=>p.classes.has('ButtonStore'));
    assert.equal(store.visible,false);
    for(const id of [1,121,601,620,673,701,801,1100,1900,3000]){
        e.publish('0',profile('0','0',{[id]:String(id)}));assert.equal(store.visible,true);
    }
    e.publish('0',profile(0,0,{}, {590:{1:'590',2:'1'}}));assert.equal(store.visible,true);
    e.publish('0',profile(-1,0,{}, {590:{1:'590',2:'0'}}));assert.equal(store.visible,false);
    e.publish('1',profile(100));assert.equal(store.visible,false);
    e.publish('0',profile('0','10'));assert.equal(store.visible,true);
}
const daily=environment('day_quest/day_quest.js',undefined,profile());
assert.equal(daily.timers.size,1);
daily.publish('restricted_client',{isRestrictedClient:1});
assert.equal(daily.roots['#QuestMain'].visible,false);assert.equal(daily.timers.size,0);
daily.ctx.UpdateQuestAfter();daily.publish('bpday',{});assert.equal(daily.timers.size,0);
daily.publish('restricted_client',{isRestrictedClient:0});daily.flush();
assert.equal(daily.roots['#QuestMain'].visible,true);
assert.notEqual(daily.roots['#QuestsPanel'].style.visibility,'collapse');
const one=environment('day_quest/day_quest.js',false,profile(),false,'1x1');
assert.equal(one.roots['#QuestMain'].visible,false);assert.equal(one.timers.size,0);
// Normal quest rendering and unrelated top-bar buttons match the previous scripts.
function snapshot(p){return {id:p.id,classes:[...p.classes],text:p.text,style:p.style,visible:p.visible,children:p.children.map(snapshot)}}
const normal=environment('day_quest/day_quest.js',false,profile());
const before=environment('day_quest/day_quest.js',false,profile(),true);
normal.flush();before.flush();assert.deepEqual(snapshot(normal.roots['#QuestMain']),snapshot(before.roots['#QuestMain']));
for(const restricted of [true,false]){
    const now=environment('top_menu/top_menu.js',restricted,profile(1));
    const old=environment('top_menu/top_menu.js',restricted,profile(1),true);
    assert.deepEqual(now.roots['#TopMenuCustom'].children.map(snapshot),old.roots['#TopMenuCustom'].children.map(snapshot));
}
console.log('PASS: all 8 scenarios; async profiles/flags; owned cosmetics/chests; pending quest timer cancellation; normal rendering; unchanged other menu panels and Store handler.');
