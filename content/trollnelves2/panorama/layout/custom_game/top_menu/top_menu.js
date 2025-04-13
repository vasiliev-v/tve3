var TOP_MENU_BUTTONS =
[
    
    ["ButtonStats", StatsClick],
    ["ButtonLeaderboards", LeaderboardsClick],
    ["ButtonStore", StoreClick],
    ["ButtonBattlePass", BattlePassClick],
    ["ButtonRewards", RewardsClick],
    ["ButtonInfo", InfoClick],
    ["Discord", DiscordOpen],
]

function Init()
{
    let TopMenuCustom = $("#TopMenuCustom")
    for (button_info of TOP_MENU_BUTTONS)
    {
        let button = $.CreatePanel("Panel", TopMenuCustom, "")
        button.AddClass("ButtonTopMenu")
        button.AddClass(button_info[0])
        let function_button = button_info[1]
        button.SetPanelEvent("onactivate", function_button)
    }
}

function DiscordOpen()
{
    $.DispatchEvent("ExternalBrowserGoToURL", 'https://discord.gg/tve3')
}

function StatsClick()
{
    GameUI.CustomUIConfig().CloseLeaderboardGlobal()
    GameUI.CustomUIConfig().CloseInfoGlobal()
    GameUI.CustomUIConfig().OpenStatsGlobal()
}

function LeaderboardsClick()
{
    GameUI.CustomUIConfig().CloseStatsGlobal()
    GameUI.CustomUIConfig().CloseInfoGlobal()
    GameUI.CustomUIConfig().OpenLeaderboardGlobal()
}

function InfoClick()
{
    GameUI.CustomUIConfig().CloseLeaderboardGlobal()
    GameUI.CustomUIConfig().CloseStatsGlobal()
    GameUI.CustomUIConfig().OpenInfoGlobal()
}

function BattlePassClick()
{
    GameUI.CustomUIConfig().OpenBPGlobal()
}

function RewardsClick()
{
    GameUI.CustomUIConfig().OpenRewardsGlobal()
}

function StoreClick()
{
    GameUI.CustomUIConfig().OpenStoreGlobal()
}

Init()