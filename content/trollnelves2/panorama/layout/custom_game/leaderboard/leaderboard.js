var INIT_PANEL = false
var FAKE_LEADERBOARD_LIST =
{
    1 : 
    {
        steamid: "106036878",
        troll_rating : 22,
        elves_rating : 33,
        summary_rating : 1,
        games: 100,
    },
    2 :  
    {
        steamid: "106496878",
        troll_rating : 2000,
        elves_rating : 3000,
        summary_rating : 4000,
        games: 100,
    },
    3 : 
    {
        steamid: "126096878",
        troll_rating : 2000,
        elves_rating : 12000,
        summary_rating : 1000,
        games: 100,
    },
    4 : 
    {
        steamid: "156096878",
        troll_rating : 12000,
        elves_rating : 10100,
        summary_rating : 10300,
        games: 100,
    },
    5 : 
    {
        steamid: "13096878",
        troll_rating : 10200,
        elves_rating : 10010,
        summary_rating : 12000,
        games: 100,
    },
    6 : 
    {
        steamid: "1506096878",
        troll_rating : 10020,
        elves_rating : 11000,
        summary_rating : 13000,
        games: 100,
    },
    7 : 
    {
        steamid: "506096878",
        troll_rating : 10100,
        elves_rating : 10200,
        summary_rating : 13000,
        games: 100,
    },
    8 : 
    {
        steamid: "206096878",
        troll_rating : 10100,
        elves_rating : 10200,
        summary_rating : 13000,
        games: 100,
    },
    9 : 
    {
        steamid: "706096878",
        troll_rating : 10100,
        elves_rating : 10200,
        summary_rating : 13000,
        games: 100,
    },
    10 : 
    {
        steamid: "106096878",
        troll_rating : 10100,
        elves_rating : 10200,
        summary_rating : 13000,
        games: 100,
    },
}

var FAKE_PLAYER_LOCAL =
{
    top_place: 203,
    steamid: "106096878",
    troll_rating : 10100,
    elves_rating : 10200,
    summary_rating : 13000,
    games: 100,
}

function OpenPanel()
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

function ClosePanel()
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
    let players_table = []
    for (num in FAKE_LEADERBOARD_LIST)
    {
        let player_info = FAKE_LEADERBOARD_LIST[num]
        players_table.push([player_info.steamid, player_info.summary_rating, player_info.troll_rating, player_info.elves_rating, player_info.games])
    }
    players_table.sort((a, b) => b[sort_id] - a[sort_id]);
    for (num in players_table)
    {
        CreatePlayer(num, players_table[num])
    }
}

function InitLocalPlayer()
{
    let local_player_info = [FAKE_PLAYER_LOCAL.steamid, FAKE_PLAYER_LOCAL.summary_rating, FAKE_PLAYER_LOCAL.troll_rating, FAKE_PLAYER_LOCAL.elves_rating, FAKE_PLAYER_LOCAL.games]
    CreatePlayer(FAKE_PLAYER_LOCAL["top_place"], local_player_info, true)
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
    Leaderboard_column_name_avatar.accountid = Number(player_info[0])
    
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

GameUI.CustomUIConfig().OpenLeaderboardGlobal = OpenPanel
GameUI.CustomUIConfig().CloseLeaderboardGlobal = ClosePanel