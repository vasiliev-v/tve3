"""Run with Python and lupa installed (uses LuaJIT 2.1). No network calls are made."""
from pathlib import Path
import json
import re
import subprocess
from lupa.luajit21 import LuaRuntime

ROOT = Path(__file__).resolve().parents[1]
BASE = 'game/trollnelves2/scripts/vscripts/'
SENTINEL = 'Invalid_NotOnDedicatedServer'


def source(name, original=False):
    if original:
        return subprocess.check_output(['git', '-c', 'safe.directory=' + ROOT.as_posix(),
                                        'show', 'HEAD:' + BASE + name], cwd=ROOT).decode('utf-8')
    return (ROOT / BASE / name).read_text(encoding='utf-8')


def plain(value):
    if hasattr(value, 'items'):
        return {str(k): plain(v) for k, v in value.items()}
    return value


def runtime(key, original=False):
    lua = LuaRuntime(unpack_returned_tuples=True)
    lua.globals().testKey = key
    lua.globals().encode = lambda value: json.dumps(plain(value), sort_keys=True)
    lua.execute('''
        require = function() end
        class = function() return {} end
        print = function() end
        DebugPrint = function() end
        GetDedicatedServerKeyV3 = function() return testKey end
        IsServer = function() return true end
        GetMapName = function() return mapName or "classic" end
        DOTA_MAX_TEAM_PLAYERS = 0
        GameRules = {server="https://example.invalid/test/", MapSpeed=1,
            isTesting=true, FakeList={}, Progress=3,
            Script_GetMatchID=function() return 123 end, IsCheatMode=function() return false end}
        PlayerResource = {GetSteamID=function() return "76561198000000000" end,
            IsValidPlayerID=function() return true end, IsFakeClient=function() return false end}
        playerData = {['0']={}, ['1']={}, ['5']={}, ['12']={}, ['7']={['0']=10000},
            ['14']={}, ['15']={['0']="premium"}}
        GameRules.PoolTable=playerData
        net = {['0']=playerData}
        CustomNetTables = {
            SetTableValue=function(_, tableName, key, value) net[key]=value end,
            GetTableValue=function(_, tableName, key) return net[key] end}
        game_spells_lib = {spells_list={}, PLAYER_INFO={}}
        json = {encode=encode, decode=function() return {} end}
        requests = {}
        Timers = {CreateTimer=function(_, delay, callback) timerCallback=callback end}
        function CreateHTTPRequestScriptVM(method, url)
            local request = {method=method, url=url, headers={}}
            requests[#requests+1]=request
            function request:SetHTTPRequestHeaderValue(key, value) self.headers[key]=value end
            function request:SetHTTPRequestRawPostBody(kind, body) self.kind=kind self.body=body end
            function request:Send(callback) self.sent=true self.callback=callback end
            return request
        end
    ''')
    lua.execute(source('settings.lua'))  # real predicate and net-table publication
    for name in ['error_debug.lua', 'stats.lua', 'clanwars.lua', 'donate_store/shop.lua']:
        lua.execute(source(name, original))
    lua.execute('''
        Shop.DonateList={{601, "gem", 10}}
        Shop.free_rewards={{"1", "601", "reward", "1", "1001"}}
        Shop.donate_rewards={}
    ''')
    return lua


def request_log(lua):
    return [{k: plain(req[k]) for k in ['method', 'url', 'headers', 'kind', 'body', 'sent']}
            for _, req in lua.globals().requests.items()]


writes = [
    'Shop.GetSkill({PlayerID=0, SteamID="steam", Num="skill", Coint=10})',
    'Shop.GetVip({PlayerID=0, SteamID="steam", Num="2", Type="skin"})',
    'Shop:BuyShopItem({PlayerID=0, Num=601, TypeDonate="gem"})',
    'Shop:BuyOpenChests({PlayerID=0, Num="601", TypeDonate="chests"})',
    'Shop.GetGem({playerID=0, SteamID="steam", Gem=50, Gold=0})',
    'Shop:EventRewards({PlayerID=0, count=25, type=1})',
    'Shop:EventBattlePass({PlayerID=0, Type="1001"})',
    'Shop.GetXpBattlepass(0)', 'Shop.GetGetGemChest(0)',
    'Shop.GetDayDone({SteamID="steam", Progress=1, count=10})',
    'Stats.SendData({SteamID="steam", Key=dedicatedServerKey, Score=10})',
    'Clanwars.SendData({SteamID="steam", Key=dedicatedServerKey, Score=10})',
    'Error_debug.SendData({Log="test", Srok=""})',
]
for call in writes:
    restricted = runtime(SENTINEL)
    restricted.execute(call)
    assert request_log(restricted) == [], call
    before, after = runtime('normal-key', True), runtime('normal-key')
    before.execute(call)
    after.execute(call)
    assert len(request_log(after)) == 1, call
    assert request_log(before) == request_log(after), call

# All eight active GET call sites remain reachable in restricted mode, with unchanged requests.
reads = [
    'GameRules.MapSpeed=1; Shop.RequestDonate(0,"steam")',
    'GameRules.MapSpeed=2; Shop.RequestDonate(0,"steam")',
    'GameRules.MapSpeed=4; Shop.RequestDonate(0,"steam")',
    'GameRules.MapSpeed=1; mapName="1x1"; Shop.RequestDonate(0,"steam")',
    'Shop.RequestBpDay()', 'Stats.RequestDataTime()',
    'Stats.RequestLastTop("1")', 'Stats.RequestDataTop10("1")',
]
for call in reads:
    before, after = runtime(SENTINEL, True), runtime(SENTINEL)
    before.execute(call)
    after.execute(call)
    assert request_log(before) == request_log(after), call
    assert request_log(after) and all(r['method'] == 'GET' for r in request_log(after)), call

# Failed READs must not turn into error-report POSTs; existing read retries still execute.
lua = runtime(SENTINEL)
lua.execute('Shop.RequestBpDay(); requests[1].callback({StatusCode=500, Body="failure"})')
assert len(request_log(lua)) == 1
lua = runtime(SENTINEL)
lua.execute('Stats.RequestDataTime(); requests[1].callback({StatusCode=500, Body="failure"}); timerCallback()')
assert len(request_log(lua)) == 2 and all(r['method'] == 'GET' for r in request_log(lua))

# Compile complete edited Lua files, including the project's goto statements.
edited = ['settings.lua', 'error_debug.lua', 'stats.lua', 'clanwars.lua', 'donate_store/shop.lua',
          'donate_store/wearables.lua', 'donate_store/selectpets.lua', 'custom_abilities.lua',
          'game_spells_lib.lua', 'libraries/buildinghelper.lua', 'drop.lua']
compiler = LuaRuntime(unpack_returned_tuples=True)
for name in edited:
    result = compiler.eval('loadstring')(source(name), name)
    assert not isinstance(result, tuple), (name, result)


def function_body(lua, file, name, original=False):
    """Extract an actual function using Lua's parser, without running unrelated game setup."""
    text = source(file, original)
    match = re.search(r'function ' + re.escape(name) + r'\(([^\n]*?)\)', text)
    assert match, name
    args = ('self' + (', ' if match[1] else '') if ':' in name else '') + match[1]
    tail = text[match.end():]
    for end in re.finditer(r'\bend\b', tail):
        code = 'return function(' + args + ')' + tail[:end.end()]
        chunk = lua.eval('loadstring')(code)
        if not isinstance(chunk, tuple):
            return chunk()
    raise AssertionError(name)


# Direct high-level entries must return before touching missing player objects or consuming items.
entries = {
    'custom_abilities.lua': ['ItemGetGem', 'ItemGetGold', 'ItemEffect', 'ItemEvent', 'ItemEventStresS',
                           'ItemEventDesert', 'ItemEventWinter', 'ItemEventHelheim', 'ItemEventBirthday'],
    'donate_store/wearables.lua': ['wearables:SetDefault' + n for n in ['Part', 'Label', 'Skin', 'SkinTower', 'SkinWisp']],
    'donate_store/selectpets.lua': ['SelectPets:SetDefaultPets'],
    'game_spells_lib.lua': ['game_spells_lib:event_upgrade_spell'],
    'donate_store/shop.lua': ['Shop:OpenChestAnimation', 'Shop:GetReward', 'SetDefaultStats', 'Shop:Statistics'],
}
for file, names in entries.items():
    for name in names:
        lua = runtime(SENTINEL)
        fn = function_body(lua, file, name)
        fn(None, lua.table()) if ':' in name else fn(lua.table())
        assert request_log(lua) == [], name

# Saved-setting restoration remains local and functional.
lua = runtime(SENTINEL)
lua.execute('GameRules.PlayersFPS={}; Shop:Statistics({id=0,PlayerID=0,type="fps",count=1},1)')
assert lua.globals().GameRules.PlayersFPS[0] is True
assert request_log(lua) == []

# Inventory local selection is independent of the persistence event. Exercise the
# actual handlers with engine objects mocked, then attempt each default-save event.
inventory_cases = [
    ('pet', 'SelectPets:SelectPets', 'SelectPets:SetDefaultPets', '121'),
    ('effect', 'wearables:SelectPart', 'wearables:SetDefaultPart', '21'),
    ('skin', 'wearables:SelectSkin', 'wearables:SetDefaultSkin', '601'),
    ('wolf', 'wearables:SelectSkin', 'wearables:SetDefaultSkin', '620'),
    ('bear', 'wearables:SelectSkin', 'wearables:SetDefaultSkin', '673'),
    ('label', 'wearables:SelectLabel', 'wearables:SetDefaultLabel', '1900'),
    *[(kind, 'wearables:SelectSkinTower', 'wearables:SetDefaultSkinTower', '701')
      for kind in ['tower', 'true_sight_tower', 'high_true_sight_tower', 'flag']],
    ('wisp', 'wearables:SelectSkinWisp', 'wearables:SetDefaultSkinWisp', '801'),
]
for key in [SENTINEL, 'normal-key']:
    for kind, select_name, default_name, part in inventory_cases:
        logs = []
        for original in [True, False]:
            lua = runtime(key, original)
            lua.globals().slot = kind
            lua.globals().itemPart = part
            lua.execute('''
                GameRules.SkinTower={[0]={}}
                GameRules.SaveDefItem={[0]={}}
                i=0 -- existing pet default handler's legacy publication index
                localCalls=0
                published=0
                hero={IsNull=function() return false end,
                    IsWolf=function() return false end, IsElf=function() return false end,
                    RemoveModifierByName=function() localCalls=localCalls+1 end,
                    AddNewModifier=function() localCalls=localCalls+1 end}
                PlayerResource.GetSelectedHeroEntity=function() return hero end
                PlayerResource.GetPlayer=function() return {} end
                PlayerResource.GetPlayerName=function() return 'player' end
                PlayerResource.GetSelectedHeroName=function() return 'hero' end
                CustomGameEventManager={Send_ServerToAllClients=function() end}
                CustomNetTables.GetTableValue=function(_, name, id)
                    if name=='Pets_Tabel' or name=='Particles_Tabel' then return {[itemPart]=true} end
                    return net[id]
                end
                CustomNetTables.SetTableValue=function(_, name, id, value)
                    if name=='Shop_active' then
                        published=published+1
                        activeValue=value[slot]
                    else net[id]=value end
                end
                Pets={DeletePet=function() localCalls=localCalls+1 end,
                    CreatePet=function() localCalls=localCalls+1 end}
                wearables={ApplyDefaultModel=function() localCalls=localCalls+1 end}
                function SetModelVip() localCalls=localCalls+1 GameRules.SkinTower[0][slot]=itemPart end
                function SetModelStandart() localCalls=localCalls+1 GameRules.SkinTower[0][slot]=nil end
                SetLabelVip=SetModelVip
                SetLabelStandart=SetModelStandart
                SetModelVipTower=function() localCalls=localCalls+1 end
                SetModelVipWisp=function() localCalls=localCalls+1 end
                FrameTime=function() return 0 end
                Timers.CreateTimer=function(_, delay, fn) fn() end
            ''')
            file = 'donate_store/selectpets.lua' if kind == 'pet' else 'donate_store/wearables.lua'
            select = function_body(lua, file, select_name, original)
            default = function_body(lua, file, default_name, original)
            for off in [0, 1]:  # Panorama boolean transport is numeric in Lua.
                info = lua.table_from({'PlayerID': 0, 'part': part, 'offp': off, 'type': kind})
                previous_requests = len(request_log(lua))
                select(None, info)
                assert len(request_log(lua)) == previous_requests, (kind, 'local selection wrote HTTP')
                assert lua.globals().activeValue == (part if off == 0 else None), (key, kind, off)
                assert lua.globals().published > off, (kind, 'missing UI publication')
                default(None, lua.table_from({'PlayerID': 0, 'part': part if off == 0 else '0', 'type': kind}))
                assert len(request_log(lua)) == (0 if key == SENTINEL else off + 1), (key, kind, off)
            assert lua.globals().localCalls > 0, kind
            if key == SENTINEL:
                assert plain(lua.globals().GameRules.SaveDefItem[0]) == {}, kind
            logs.append(request_log(lua))
        assert logs[0] == logs[1], (key, kind, 'normal default request changed')

assert runtime(SENTINEL).globals().net.restricted_client.isRestrictedClient is True
assert runtime('normal-key').globals().net.restricted_client.isRestrictedClient is False

# The existing order filter receives native cast orders in either mode.
for key in [SENTINEL, 'normal-key']:
    lua = runtime(key)
    lua.execute('BuildingHelper={nextFilter=function() delegated=true return false end}')
    fn = function_body(lua, 'libraries/buildinghelper.lua', 'BuildingHelper:OrderFilter')
    assert fn(None, lua.table_from({'order_type': 8, 'entindex_ability': 1})) is False
    assert lua.globals().delegated is True

# Drop entry points stop before random rolls, counters, timers or item creation.
drop_calls = ['drop:RollItemDrop(unit)', 'RandomDropLoot("item_vip")',
              'TimerRandomDrop({caster=unit})', 'TimerRandomDropWinter({caster=unit})']
for call in drop_calls:
    lua = runtime(SENTINEL)
    lua.execute(source('drop.lua'))
    limits = [entry.limit for _, entry in lua.globals().item_drop.items()]
    lua.execute(call)  # No engine unit/random/item mocks: touching any would fail.
    assert lua.globals().timerCallback is None, call
    assert [entry.limit for _, entry in lua.globals().item_drop.items()] == limits, call

    # Compare all drop side effects and timer repetitions to the pre-change code.
    for key in ['normal-key', '', 'Invalid_NotOnDedicatedServer_extra']:
        results = []
        for original in [True, False]:
            lua = runtime(key)
            lua.execute('''
                operations={}
                function record(...) operations[#operations+1]={...} end
                local vec=setmetatable({x=10,y=20}, {__add=function(a,b) return a end})
                Vector=function(...) record('vector', ...) return vec end
                RandomVector=function(n) record('randomVector',n) return vec end
                unit={GetUnitName=function() return 'npc_dota_hero_treant' end,
                    GetAbsOrigin=function() return vec end}
                GameRules.PlayersCount=10
                GameRules.MIN_RATING_PLAYER=1
                SEASON_ITEM='item_season'
                RandomInt=function(a,b) record('randomInt',a,b) return a end
                RandomFloat=function(a,b) record('randomFloat',a,b) return a end
                DropLootByRules=function(name,point,low,high,height,duration)
                    record('drop',name,low,high,height,duration)
                end
                CreateItem=function(name)
                    record('item',name)
                    return {LaunchLootInitialHeight=function(_,a,b,c,d) record('launch',a,b,c,d) end,
                        SetContextThink=function(_,name,fn,delay) record('cleanup',name,delay) end}
                end
                CreateItemOnPositionForLaunch=function() record('container') return {} end
                MinimapEvent=function() record('minimap') end
                AddFOWViewer=function() record('vision') end
                pending={}
                Timers.CreateTimer=function(_,delay,fn)
                    if type(delay)=='function' then fn=delay delay=0 end
                    record('timer',delay)
                    pending[#pending+1]=fn
                end
                function drain()
                    for _,fn in ipairs(pending) do
                        for count=1,250 do
                            local delay=fn()
                            if not delay then break end
                            record('repeat',delay)
                            assert(count<250, 'unbounded timer')
                        end
                    end
                end
            ''')
            lua.execute(source('drop.lua', original))
            lua.execute(call + '; drain()')
            result = plain(lua.globals().operations)
            assert result, call
            results.append((result, plain(lua.globals().item_drop)))
        assert results[0] == results[1], (key, call)

print('PASS: Lua syntax; 13 blocked writes and normal request/payload comparisons; 8 active READ sites; retries; 20 higher-level guards; saved settings.')
print('PASS: 11 inventory cosmetic cases equip/unequip and publish active state; zero restricted writes/default counters; normal default requests match HEAD. Engine application helpers are mocked.')
print('PASS: four drop entry points skip all side effects for the exact sentinel; other keys match HEAD drops, timers and limits.')


def perk_runtime(enabled, saved, original=False):
    lua = runtime('normal-key', original)
    lua.globals().saved = saved
    lua.execute('''
        tables={Shop={['0']={['0']={['1']=1000000000},
            ['12']={['1']={['1']='elf_spell_gold',['2']=saved}, metadata=true}}},game_spells_lib={}}
        tables.Shop['0'][12]=tables.Shop['0']['12']
        CustomNetTables.GetTableValue=function(_,name,key) return tables[name] and tables[name][key] end
        CustomNetTables.SetTableValue=function(_,name,key,value)
            tables[name]=tables[name] or {} tables[name][key]=value
        end
        GameRules.SPELL_PRICE_BASE=10000
        GameRules.PoolTable[18]={}
        GameRules.SPELL_DISCOUNT_TO_2=0.2
        GameRules.SPELL_DISCOUNT_TO_3=0.3
        GameRules.TROLL_DISCOUNT=0.1
        DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP=1
        DOTA_TEAM_GOODGUYS=2 DOTA_TEAM_BADGUYS=3
        phase=1
        GameRules.State_Get=function() return phase end
        PlayerResource.GetTeam=function() return 2 end
        PlayerResource.GetPlayer=function() return {} end
        modifier={SetStackCount=function(self,n) self.stack=n end, GetStackCount=function(self) return self.stack end}
        hero={IsElf=function() return true end, IsTroll=function() return false end,
            HasModifier=function() return false end,
            AddNewModifier=function() return modifier end}
        PlayerResource.GetSelectedHeroEntity=function() return hero end
        CustomGameEventManager={Send_ServerToPlayer=function() notifications=(notifications or 0)+1 end}
    ''')
    # Exercise real setting publication, then load the complete perk library.
    lua.execute(source('settings.lua').replace('ENABLE_PERK_UPGRADES = true',
                                             'ENABLE_PERK_UPGRADES = ' + str(enabled).lower()))
    lua.execute(source('game_spells_lib.lua', original))
    assert lua.globals().tables.game_spells_lib.settings.enable_perk_upgrades == enabled
    return lua


for enabled in [False, True]:
    for saved in [1, 2, 3]:
        lua = perk_runtime(enabled, saved)
        effective = saved if enabled else 1
        assert lua.eval('game_spells_lib:GetSpellLevel(0,"elf_spell_gold")') == effective
        assert lua.eval('game_spells_lib:GetSpellLevel(0,"missing")') == 0
        # Actual custom event selection toggles, and the application paths set LVL 1 stacks.
        lua.execute('''
            selection={PlayerID=0,spell_name='elf_spell_gold',modifier_name='modifier_elf_spell_gold'}
            game_spells_lib:event_set_activate_spell(selection)
            assert(game_spells_lib:FindCurrentSpellPlayer(0,'elf_spell_gold'))
            game_spells_lib:event_set_activate_spell(selection)
            assert(not game_spells_lib:FindCurrentSpellPlayer(0,'elf_spell_gold'))
            game_spells_lib:event_set_activate_spell(selection)
            phase=2
            game_spells_lib:SetSpellPlayers(0)
        ''')
        assert lua.globals().modifier.stack == effective
        lua.execute('game_spells_lib:AddPlayerSpell(0,"elf_spell_gold","modifier_elf_spell_gold",hero)')
        assert lua.globals().modifier.stack == effective
        # Execute a real level-dependent modifier property, without changing its values.
        effect = function_body(lua, 'modifiers/modifier_elf_spell_gold.lua',
                               'modifier_elf_spell_gold:GetModifierMoveSpeedBonus_Constant')
        assert effect(lua.globals().modifier) == {1: -20, 2: -10, 3: 0}[effective]
        assert lua.globals().tables.Shop['0']['12']['1']['2'] == saved
        if not enabled:
            before = plain(lua.globals().tables.Shop['0'])
            lua.execute('''
                game_spells_lib:event_upgrade_spell({PlayerID=0,spell_name='elf_spell_gold'})
                game_spells_lib:PlayerUpgradeSpellSelected(0,'elf_spell_gold')
                game_spells_lib:PlayerUpgradeSpell(0,0)
            ''')
            assert plain(lua.globals().tables.Shop['0']) == before
            assert request_log(lua) == []
            assert lua.globals().notifications is None
        else:
            results = []
            for original in [True, False]:
                normal = perk_runtime(True, saved, original)
                normal.execute('game_spells_lib:event_upgrade_spell({PlayerID=0,spell_name="elf_spell_gold"})')
                assert len(request_log(normal)) == (1 if saved < 3 else 0)
                results.append((request_log(normal), plain(normal.globals().tables.Shop['0'])))
            assert results[0] == results[1], saved
print('PASS: perk setting replication, selection, effective stacks/modifier effect, saved levels, direct Lua guards, zero disabled upgrade writes/cost changes, normal upgrade payload/cost equality.')
