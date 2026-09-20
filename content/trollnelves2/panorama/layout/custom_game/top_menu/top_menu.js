var TOP_MENU_BUTTONS =
[
    ["ButtonStats", StatsClick, "#TopMenu_Profile"],
    ["ButtonLeaderboards", LeaderboardsClick, "#TopMenu_Leaders"],
    ["ButtonStore", StoreClick, "#TopMenu_Shop"],
    ["ButtonBattlePass", BattlePassClick, "#TopMenu_BP"],
    ["ButtonRewards", RewardsClick, "#TopMenu_Rewards"],
    ["ButtonInfo", InfoClick, "#TopMenu_Info"],
    ["Discord", DiscordOpen, "#TopMenu_Discord"],
]

var RewardsButton = null
var updateRewardsLoop = true

function IsStoreAvailable() {
    let shop = CustomNetTables.GetTableValue("Shop", String(Players.GetLocalPlayer()))
    if (!shop) return false
    let currencies = shop[0] || {}
    return Number(currencies[0]) > 0 || Number(currencies[1]) > 0
        || Object.keys(shop[1] || {}).some(id => Number(id) > 0)
        || Object.values(shop[4] || {}).some(chest => chest && Number(chest[2]) > 0)
}

function Init() {
    let TopMenuCustom = $("#TopMenuCustom")

    for (let button_info of TOP_MENU_BUTTONS)
    {
        let button = $.CreatePanel("Panel", TopMenuCustom, "")
        button.AddClass("ButtonTopMenu")
        button.AddClass(button_info[0])

        if (["ButtonStats", "ButtonLeaderboards", "ButtonBattlePass", "ButtonRewards"].indexOf(button_info[0]) !== -1) {
            let updateVisibility = function () {
                if (button.IsValid()) button.visible = !GameUI.CustomUIConfig().IsRestrictedClient()
            }
            updateVisibility()
            CustomNetTables.SubscribeNetTableListener("Shop", function (table, key) {
                if (key === "restricted_client") updateVisibility()
            })
        }

        if (button_info[0] == "ButtonStore") {
            let updateStoreVisibility = function () {
                if (button.IsValid()) button.visible = IsStoreAvailable()
            }
            updateStoreVisibility()
            CustomNetTables.SubscribeNetTableListener("Shop", function (table, key) {
                if (String(key) === String(Players.GetLocalPlayer())) updateStoreVisibility()
            })
        }

        if (button_info[0] == "ButtonRewards") {
            RewardsButton = button
        }

        let function_button = button_info[1]
        button.SetPanelEvent("onactivate", function_button)

        // Текст снизу
        let label = $.CreatePanel("Label", button, "")
        label.AddClass("ButtonTopMenuText")
        label.text = $.Localize(button_info[2]) || ""
    }

    UpdateRewardsButtonLoop()
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