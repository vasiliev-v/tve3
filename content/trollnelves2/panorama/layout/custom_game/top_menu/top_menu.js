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

var RewardsButton = null
var updateRewardsLoop = true

function Init() {
    let TopMenuCustom = $("#TopMenuCustom")
    for (let button_info of TOP_MENU_BUTTONS) {
        let button = $.CreatePanel("Panel", TopMenuCustom, "")
        button.AddClass("ButtonTopMenu")
        button.AddClass(button_info[0])
        if (button_info[0] == "ButtonRewards") {
            RewardsButton = button
        }
        let function_button = button_info[1]
        button.SetPanelEvent("onactivate", function_button)
    }

    UpdateRewardsButtonLoop() // Запускаем цикл
}

function UpdateRewardsButtonLoop() {
    if (!updateRewardsLoop) {
        return
    }

    UpdateRewardsButton()

    // Следующий вызов через 1 секунду
    $.Schedule(5, UpdateRewardsButtonLoop)
}

function UpdateRewardsButton() {
    if (!RewardsButton) {
        return
    }

    let shop_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())
    if (!shop_table || !shop_table[6]) {
        return
    }

    let daily_info = shop_table[6]

    if (Number(daily_info[0]) < Number(daily_info[1])) {
        RewardsButton.AddClass("Unclaimed")
    } else {
        RewardsButton.RemoveClass("Unclaimed")
        updateRewardsLoop = false // Отключаем цикл при получении награды
    }
}

function DiscordOpen()
{
    $.DispatchEvent("ExternalBrowserGoToURL", 'https://discord.gg/tve4')
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