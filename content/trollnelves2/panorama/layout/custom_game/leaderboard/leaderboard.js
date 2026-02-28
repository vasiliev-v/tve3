var INIT_PANEL = false
var HAS_PLAYER_IN_ALL_TABLE = false
var FAKE_LEADERBOARD_LIST =
{

}
var FAKE_PLAYER_LOCAL =
{
}
/*
var FAKE_PLAYER_LOCAL =
{
    top_place: 203,
    steamid: "106096878",
    troll_rating : 10100,
    elves_rating : 10200,
    summary_rating : 13000,
    games: 100,
}
*/



function Leaderboard_OpenPanel()
{
    let Leaderboard = $("#Leaderboard")
    Leaderboard.SetHasClass("Open", !Leaderboard.BHasClass("Open"))
    if (!INIT_PANEL)
    {
        INIT_PANEL = true
        InitPlayersRating(1)
        InitLocalPlayer()
    }
}

function Leaderboard_ClosePanel()
{
    let Leaderboard = $("#Leaderboard")
    if (Leaderboard.BHasClass("Open"))
    {
        Leaderboard.SetHasClass("Open", false)
    }
}

function InitPlayersRating(sort_id)
{
    let PlayersList = $("#PlayersList")
    PlayersList.RemoveAndDeleteChildren()
    FAKE_LEADERBOARD_LIST = CustomNetTables.GetTableValue("Shop", "top10")
    let players_table = []
    for (num in FAKE_LEADERBOARD_LIST)
    {
        let player_info = FAKE_LEADERBOARD_LIST[num]
        players_table.push([player_info[1], player_info[2], player_info[3], player_info[4], player_info[5]])
    }
    players_table.sort((a, b) => b[sort_id] - a[sort_id]);
    for (num in players_table)
    {
        IsCondLocalPlayer(players_table[num])
        CreatePlayer(num, players_table[num])
    }
}

function IsCondLocalPlayer(players_table)
{
    let shop_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))?.[13];
    if (!shop_table) { return }
    let local_player_info = [shop_table[2], shop_table[3], shop_table[4], shop_table[5], shop_table[6]]
    if (players_table[0] == local_player_info[0])
    {
        HAS_PLAYER_IN_ALL_TABLE = true
    }
}

function InitLocalPlayer()
{
    let shop_table = CustomNetTables.GetTableValue("Shop", Entities.GetPlayerOwnerID(Players.GetLocalPlayerPortraitUnit()))?.[13];
    if (!shop_table) { return }
    let local_player_info = [shop_table[2], shop_table[3], shop_table[4], shop_table[5], shop_table[6]]
    if (HAS_PLAYER_IN_ALL_TABLE)
    {
        return
    }
    CreatePlayer(shop_table[1], local_player_info, true)
} 

function CreatePlayer(num, player_info, is_local) 
{   
    let PlayersList = $("#PlayersList")
    if (is_local)
    {
        PlayersList = $("#LocalPlayer")
    }

    let Line = $.CreatePanel("Panel", PlayersList, "");
    Line.AddClass("LinePlayer");
    Line.AddClass("LinePlayer_"+(Number(num) + 1))

    let Leaderboard_column_id = $.CreatePanel("Label", Line, "")
    Leaderboard_column_id.AddClass("Leaderboard_column_id")
    Leaderboard_column_id.text = (Number(num) + 1)

    let Leaderboard_column_name = $.CreatePanel("Panel", Line, "")
    Leaderboard_column_name.AddClass("Leaderboard_column_name")
    Leaderboard_column_name.style.flowChildren = "right"

    let Leaderboard_column_name_avatar = $.CreatePanel("DOTAAvatarImage", Leaderboard_column_name, "", {style:"width:22px;height:22px;margin-right:10px;vertical-align:center;"})
    Leaderboard_column_name_avatar.accountid = player_info[0]
    
    let Leaderboard_column_name_label = $.CreatePanel("DOTAUserName", Leaderboard_column_name, "", {style:"vertical-align:center;"})
    Leaderboard_column_name_label.AddClass("Leaderboard_column_name_label")
    Leaderboard_column_name_label.steamid = player_info[0]

    let Leaderboard_column_sum = $.CreatePanel("Label", Line, "")
    Leaderboard_column_sum.AddClass("Leaderboard_column_sum")
    Leaderboard_column_sum.text = player_info[1]

    let Leaderboard_column_troll = $.CreatePanel("Label", Line, "")
    Leaderboard_column_troll.AddClass("Leaderboard_column_troll")
    Leaderboard_column_troll.text = player_info[2]

    let Leaderboard_column_elves = $.CreatePanel("Label", Line, "")
    Leaderboard_column_elves.AddClass("Leaderboard_column_elves")
    Leaderboard_column_elves.text = player_info[3]

    let Leaderboard_column_games = $.CreatePanel("Label", Line, "")
    Leaderboard_column_games.AddClass("Leaderboard_column_games")
    Leaderboard_column_games.text = player_info[4]
} 

GameUI.CustomUIConfig().OpenLeaderboardGlobal = Leaderboard_OpenPanel
GameUI.CustomUIConfig().CloseLeaderboardGlobal = Leaderboard_ClosePanel