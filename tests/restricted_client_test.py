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
          'game_spells_lib.lua', 'libraries/buildinghelper.lua']
compiler = LuaRuntime(unpack_returned_tuples=True)
for name in edited:
    result = compiler.eval('loadstring')(source(name), name)
    assert not isinstance(result, tuple), (name, result)


def function_body(lua, file, name):
    """Extract an actual function using Lua's parser, without running unrelated game setup."""
    text = source(file)
    match = re.search(r'function ' + re.escape(name) + r'\(([^\n]*?)\)', text)
    assert match, name
    args = ('self, ' if ':' in name else '') + match[1]
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

# Parse item KV blocks, including non-item_ names and keys followed by comments.
kv = (ROOT / 'game/trollnelves2/scripts/npc/npc_items_custom.txt').read_text(encoding='utf-8')
kv = re.sub(r'//[^\n]*', '', kv)
tokens = re.findall(r'"([^"\n]*)"|([{}])', kv)
stack, pending, redeem_items = [], None, set()
for string, brace in tokens:
    if brace == '{':
        stack.append(pending); pending = None
    elif brace == '}':
        stack.pop(); pending = None
    elif pending is None:
        pending = string
    else:
        if pending == 'Function' and string in entries['custom_abilities.lua']:
            redeem_items.add(stack[1])
        pending = None
lua = runtime(SENTINEL)
assert set(plain(lua.globals().RESTRICTED_WRITE_ITEMS)) == redeem_items
assert lua.globals().net.restricted_client.isRestrictedClient is True
assert runtime('normal-key').globals().net.restricted_client.isRestrictedClient is False

# The order filter blocks redemption hotkeys but delegates normal/local orders unchanged.
for key in [SENTINEL, 'normal-key']:
    lua = runtime(key)
    lua.execute('''
        DOTA_UNIT_ORDER_CAST_NO_TARGET=8
        BuildingHelper={nextFilter=function() delegated=true return false end}
        EntIndexToHScript=function() return {GetAbilityName=function() return itemName end} end
    ''')
    fn = function_body(lua, 'libraries/buildinghelper.lua', 'BuildingHelper:OrderFilter')
    for item in redeem_items | {'item_blink_datadriven', 'item_flicker'}:
        lua.globals().itemName = item
        lua.globals().delegated = False
        assert fn(None, lua.table_from({'order_type': 8, 'entindex_ability': 1})) is False
        assert bool(lua.globals().delegated) == (key != SENTINEL or item not in redeem_items), item

print('PASS: Lua syntax; 13 blocked writes and normal request/payload comparisons; 8 active READ sites; retries; 20 higher-level guards; saved settings; native item KV coverage and order filter.')
