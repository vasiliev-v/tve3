var PLAYERS_COUNTER_MAX = 0

function UpdateTeam( teamId )
{
    let teamPlayers = Game.GetPlayerIDsOnTeam( teamId );
    let max_players = teamPlayers.length
    if (PLAYERS_COUNTER_MAX < max_players)
    {
        $("#player_list_1").RemoveAndDeleteChildren()
        $("#player_list_2").RemoveAndDeleteChildren()
        PLAYERS_COUNTER_MAX = max_players
    }
    let player_counter = 0
	for ( var playerId of teamPlayers )
	{
        player_counter = player_counter + 1
		UpdatePlayer( playerId, player_counter, teamPlayers );
	}
    $("#GameTimerLabel").text = ConvertTimeMinutes(Math.floor(Game.GetDOTATime( false, false )))
    let TimeUntil = FindDotaHudElement("TimeUntil")
    let time_to_next_cycle = 0
    if (TimeUntil)
    {
        time_to_next_cycle = timeToSeconds(TimeUntil.text)
    }
    if (Game.IsDayTime())
    {
        $("#GameTimer").SetHasClass("IsNight", false)
        $("#TimerToNextCycle").text = TimeUntil.text
    }
    else
    {
        $("#GameTimer").SetHasClass("IsNight", true)
        $("#TimerToNextCycle").text = TimeUntil.text
    }
    $("#TimeOfDayLineFront").style.width = (time_to_next_cycle / 300 * 100) + "%"
    $.GetContextPanel().SetHasClass("AltPressed", GameUI.IsAltDown())
    $.Schedule(0.1, function()
    {
        UpdateTeam( teamId )
    })
}

function UpdatePlayer( playerId, player_counter, teamPlayers )
{
    let team_panel = $("#player_list_1")
    if ((player_counter > Math.floor(teamPlayers.length / 2)) && teamPlayers.length > 1)
    {
        team_panel = $("#player_list_2")
    }
	var playerPanelName = "player_" + playerId;
    var playerPanel = team_panel.FindChildTraverse( playerPanelName );
	if ( playerPanel === null )
	{
		playerPanel = $.CreatePanel( "Image", team_panel, playerPanelName );
		playerPanel.BLoadLayout( "file://{resources}/layout/custom_game/multiteam_top_scoreboard/multiteam_top_scoreboard_player.xml", false, false );
		playerPanel.AddClass( "PlayerPanel" );
        playerPanel.PlayerID = playerId
	}

	var playerInfo = Game.GetPlayerInfo( playerId );
	if ( !playerInfo )
		return;

	var localPlayerInfo = Game.GetLocalPlayerInfo();
	if ( !localPlayerInfo )
		return;

    playerPanel.SetHasClass( "player_dead", ( playerInfo.player_respawn_seconds >= 0 ) );

	var localPlayerTeamId = localPlayerInfo.player_team_id;
	
	if ( playerId == localPlayerInfo.player_id )
	{
		playerPanel.AddClass( "is_local_player" );
	}

    if (!playerPanel.SetColor)
    {
        var colorInt = Players.GetPlayerColor( playerId );
        if (colorInt == 0)
        {
            colorInt =  Math.floor(Math.random() * 42949278731);
        }
        var colorString = "#" + intToARGB( colorInt );
        var ElfGlow = playerPanel.FindChildInLayoutFile( "ElfGlow" );
        ElfGlow.style.washColor = colorString;
        var ElfAvatar = playerPanel.FindChildInLayoutFile( "ElfAvatar" );
        ElfAvatar.style.border = "2px solid "+ colorString;
        ElfAvatar.style.boxShadow = "0px 0px 8px -1px " + colorString
        playerPanel.SetColor = true
    }
    
	var playerName = playerPanel.FindChildInLayoutFile( "PlayerName" );
    playerName.text = Players.GetPlayerName( playerId )

	playerPanel.SetHasClass( "is_local_player", ( playerId == Game.GetLocalPlayerID() ) );
}

UpdateTeam( 2 );

let topbar = FindDotaHudElement("topbar")
if (topbar)
{
    topbar.style.opacity = "0"
}

function timeToSeconds(str) 
{
    const timePattern = /(\d{1,2}):(\d{2})/;
    const match = str.match(timePattern);
    if (match) 
    {
        const minutes = parseInt(match[1], 10);
        const seconds = parseInt(match[2], 10);
        const totalSeconds = (minutes * 60) + seconds;
        return totalSeconds;
    } 
    else 
    {
        return null;
    }
}

function intToARGB(i) 
{ 
                return ('00' + ( i & 0xFF).toString( 16 ) ).substr( -2 ) +
                                               ('00' + ( ( i >> 8 ) & 0xFF ).toString( 16 ) ).substr( -2 ) +
                                               ('00' + ( ( i >> 16 ) & 0xFF ).toString( 16 ) ).substr( -2 ) + 
                                                ('00' + ( ( i >> 24 ) & 0xFF ).toString( 16 ) ).substr( -2 );
}