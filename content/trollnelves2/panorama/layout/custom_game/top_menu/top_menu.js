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

function GetPlayerMMR() {
    let pId = Players.GetLocalPlayer()
    let shop_table = CustomNetTables.GetTableValue("Shop", pId)
    if (!shop_table) return 0
    // shop_table[13] = {rank, steamID, sum, troll, elf, games} — данные из топ-таблицы
    let rating_data = shop_table[13]
    if (rating_data && Number(rating_data[3]) != null) {
        return Number(rating_data[3]) + Number(rating_data[4] || 0)
    }
    // Запасной вариант: читать из raw score полей
    let elf_data = shop_table[8] && shop_table[8][0]
    let troll_data = shop_table[9] && shop_table[9][0]
    let elf = (elf_data && Number(elf_data.score)) || 0
    let troll = (troll_data && Number(troll_data.score)) || 0
    return elf + troll
}

function Init() {
    let TopMenuCustom = $("#TopMenuCustom")

    for (let button_info of TOP_MENU_BUTTONS)
    {
        let button = $.CreatePanel("Panel", TopMenuCustom, "")
        button.AddClass("ButtonTopMenu")
        button.AddClass(button_info[0])

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
    CheckMMRVisibility()
}

function CheckMMRVisibility() {
    let mmr = GetPlayerMMR()
    let TopMenuCustom = $("#TopMenuCustom")
    if (isNaN(mmr) || mmr > 100) {
        TopMenuCustom.style.visibility = "visible"
        return
    }
    // Таблица ещё не загрузилась — повторить через 2 сек
    TopMenuCustom.style.visibility = "collapse"
    $.Schedule(2, CheckMMRVisibility)
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