"use strict";

var HIDE_QUESTS_PANEL = Game.GetMapInfo().map_display_name == "1x1";

var quest_information_table = {};
var player_table = [0, []];

var QUESTS_REBUILD_PENDING = false;
var QUESTS_REBUILD_DELAY = 0.10;
var QUESTS_INITIALIZED = false;

(function forceHideFor1x1() {
    if (!HIDE_QUESTS_PANEL) return;

    const root = $.GetContextPanel();
    root.AddClass("hide-quests");

    let shadow = root.FindChildTraverse("PanelShadow");
    if (!shadow) {
        const shadows = root.FindChildrenWithClassTraverse("PanelShadow");
        if (shadows.length) shadow = shadows[0];
    }

    if (shadow) {
        shadow.style.visibility = "collapse";
        shadow.style.opacity = "0";
        shadow.style.transform = "none";
        shadow.DeleteAsync(0);
    }

    ["QuestPanelSwap", "QuestsPanel", "QuestMain"].forEach(id => {
        const p = root.FindChildTraverse(id);
        if (p) {
            p.style.visibility = "collapse";
            p.style.opacity = "0";
            p.style.transform = "none";
        }
    });

    const qm = root.FindChildTraverse("QuestMain");
    if (qm) qm.SetHasClass("Open", false);
})();

function ToggleInfo() {
    if (HIDE_QUESTS_PANEL) return;

    const main = $("#QuestMain");
    if (!main) return;

    main.SetHasClass("Open", !main.BHasClass("Open"));
}

function GetLocalPlayerKey() {
    return String(Players.GetLocalPlayer());
}

function GetShopPlayerTable() {
    return CustomNetTables.GetTableValue("Shop", GetLocalPlayerKey());
}

function GetShopBpDayTable() {
    return CustomNetTables.GetTableValue("Shop", "bpday");
}

function IsQuestDataReady() {
    const shopBpDay = GetShopBpDayTable();
    const shopPlayer = GetShopPlayerTable();

    if (!shopBpDay || !shopPlayer) return false;
    if (!shopPlayer[10] || !shopPlayer[15]) return false;

    return true;
}

function RefreshQuestCache() {
    const shopBpDay = GetShopBpDayTable();
    const shopPlayer = GetShopPlayerTable();

    if (!shopBpDay || !shopPlayer || !shopPlayer[10] || !shopPlayer[15]) {
        return false;
    }

    quest_information_table = shopBpDay;
    player_table[1] = shopPlayer[10];
    player_table[0] = shopPlayer[15];

    return true;
}

function HasBattlePass() {
    return !!(player_table[0] && player_table[0][0] != "none");
}

function ScheduleRebuild(delay) {
    if (HIDE_QUESTS_PANEL) return;
    if (QUESTS_REBUILD_PENDING) return;

    QUESTS_REBUILD_PENDING = true;

    $.Schedule(delay || QUESTS_REBUILD_DELAY, function () {
        QUESTS_REBUILD_PENDING = false;
        RebuildQuests();
    });
}

function RebuildQuests() {
    if (HIDE_QUESTS_PANEL) return;

    const questsPanel = $("#QuestsPanel");
    if (!questsPanel) {
        ScheduleRebuild(0.2);
        return;
    }

    if (!RefreshQuestCache()) {
        ScheduleRebuild(0.5);
        return;
    }

    questsPanel.RemoveAndDeleteChildren();

    const header = $.CreatePanel("Panel", questsPanel, "");
    header.AddClass("QuestPanelInformation");

    const headerLabel = $.CreatePanel("Label", header, "");
    headerLabel.text = $.Localize("#troll_quest_title");

    CreateQuestInfoBlock(questsPanel);

    const has_battlepass = HasBattlePass();
    const sortedQuests = Object.values(quest_information_table).sort((a, b) => {
        const ta = Number(a.type) || 0;
        const tb = Number(b.type) || 0;
        return ta - tb;
    });

    for (let i = 0; i < sortedQuests.length; i++) {
        CreateQuest(sortedQuests[i], has_battlepass);
    }
}

function FindPlayerQuestData(questId) {
    if (!player_table[1] || !player_table[1][1]) return null;

    const entries = player_table[1][1];
    const length = Object.keys(entries).length;

    for (let i = 1; i <= length; i++) {
        if (!entries[i]) continue;

        if (Number(entries[i][1]) === Number(questId)) {
            return entries[i];
        }
    }

    return null;
}

function CreateQuest(quest_player_table, has_battlepass) {
    if (!quest_player_table) return;

    const questData = FindPlayerQuestData(quest_player_table.id);
    if (!questData) return;

    const questsPanel = $("#QuestsPanel");
    if (!questsPanel) return;

    let is_locked_quest_battlepass = false;
    if (String(quest_player_table.donate) === "1" && !has_battlepass) {
        is_locked_quest_battlepass = true;
    }

    const DayQuest = $.CreatePanel("Panel", questsPanel, "quest_id_" + quest_player_table.id);
    DayQuest.AddClass("DayQuest");
    if (is_locked_quest_battlepass) {
        DayQuest.AddClass("LockedQuest");
    }

    const QuestIcon = $.CreatePanel("Panel", DayQuest, "");
    QuestIcon.AddClass("QuestIcon");

    const QuestInfo = $.CreatePanel("Panel", DayQuest, "");
    QuestInfo.AddClass("QuestInfo");

    const QuestName = $.CreatePanel("Label", QuestInfo, "");
    QuestName.AddClass("QuestName");

    if (is_locked_quest_battlepass) {
        QuestName.text = $.Localize("#quest_locked");
    } else {
        QuestName.text = $.Localize("#" + quest_player_table.name);
        QuestIcon.style.backgroundImage = 'url("file://{images}/custom_game/quest/icons/' + quest_player_table.icon + '.png")';
        QuestIcon.style.backgroundSize = "100%";
    }

    const QuestProgress = $.CreatePanel("Panel", QuestInfo, "");
    QuestProgress.AddClass("QuestProgress");

    const QuestProgressBackground = $.CreatePanel("Panel", QuestProgress, "");
    QuestProgressBackground.AddClass("QuestProgressBackground");

    const QuestProgressLine = $.CreatePanel("Panel", QuestProgress, "QuestProgressLine");
    QuestProgressLine.AddClass("QuestProgressLine");

    const currentCount = Number(questData[2]) || 0;
    const maxCount = Number(quest_player_table.count) || 0;
    const progressPercent = maxCount > 0 ? Math.min(100, (currentCount * 100) / maxCount) : 0;

    QuestProgressLine.style.width = progressPercent + "%";

    const QuestProgressLabel = $.CreatePanel("Label", QuestProgress, "QuestProgressLabel");
    QuestProgressLabel.AddClass("QuestProgressLabel");
    QuestProgressLabel.text = currentCount + " / " + maxCount;

    const QuestRewardLabel = $.CreatePanel("Label", QuestInfo, "");
    QuestRewardLabel.AddClass("QuestRewardLabel");

    if (is_locked_quest_battlepass) {
        QuestRewardLabel.text = $.Localize("#quest_locked_buy_battlepass");
    } else {
        QuestRewardLabel.text = $.Localize("#" + quest_player_table.reward);
    }

    const QuestSucces = $.CreatePanel("Panel", QuestIcon, "");
    QuestSucces.AddClass("QuestSucces");

    const QuestSuccesIcon = $.CreatePanel("Panel", QuestIcon, "QuestSuccesIcon");
    QuestSuccesIcon.AddClass("QuestSuccesIcon");

    if (currentCount >= maxCount && maxCount > 0) {
        DayQuest.AddClass("QuestComplete");
    }

    const QuestLockedBG = $.CreatePanel("Panel", QuestIcon, "");
    QuestLockedBG.AddClass("QuestLockedBG");

    const QuestLockedBGIcon = $.CreatePanel("Panel", QuestIcon, "");
    QuestLockedBGIcon.AddClass("QuestLockedBGIcon");
}

function OnShopTableChanged(tableName, key, data) {
    if (HIDE_QUESTS_PANEL) return;

    const localPlayerKey = GetLocalPlayerKey();

    if (key !== "bpday" && key !== localPlayerKey) {
        return;
    }

    ScheduleRebuild(0.05);
}

function UpdateQuestAfter() {
    if (HIDE_QUESTS_PANEL) {
        const root = $.GetContextPanel();

        const qp = $("#QuestsPanel");
        if (qp) qp.style.visibility = "collapse";

        const swap = $("#QuestPanelSwap");
        if (swap) swap.style.visibility = "collapse";

        const shadow = $("#PanelShadow") || root.FindChildrenWithClassTraverse("PanelShadow")[0];
        if (shadow) shadow.style.visibility = "collapse";

        return;
    }

    ScheduleRebuild(0.05);
}

function InitQuests() {
    if (QUESTS_INITIALIZED) return;
    QUESTS_INITIALIZED = true;

    if (HIDE_QUESTS_PANEL) {
        const questsPanel = $("#QuestsPanel");
        if (questsPanel) questsPanel.style.visibility = "collapse";

        const questsPanelSwap = $("#QuestPanelSwap");
        if (questsPanelSwap) questsPanelSwap.style.visibility = "collapse";

        const panelShadow = $("#PanelShadow") || $.GetContextPanel().FindChildrenWithClassTraverse("PanelShadow")[0];
        if (panelShadow) panelShadow.style.visibility = "collapse";

        return;
    }

    CustomNetTables.SubscribeNetTableListener("Shop", OnShopTableChanged);
    GameEvents.SubscribeProtected("troll_quest_update_after", UpdateQuestAfter);

    ScheduleRebuild(0.01);
}

function GetQuestTimeText()
{
    const mapInfo = Game.GetMapInfo();
    const mapName = mapInfo.map_display_name;

    // пример проверки режима
    if (mapName == "classic4x") {
        return "15";
    }

    return "20";
}

function CreateQuestInfoBlock(parent)
{
    const block = $.CreatePanel("Panel", parent, "QuestInfoBlock");
    block.AddClass("QuestInfoBlock");

    //const icon = $.CreatePanel("Panel", block, "");
    //icon.AddClass("QuestInfoBlockIcon");

    const textWrap = $.CreatePanel("Panel", block, "");
    textWrap.AddClass("QuestInfoBlockTextWrap");

    const title = $.CreatePanel("Label", textWrap, "");
    title.AddClass("QuestInfoBlockTitle");
    title.text = $.Localize("#quest_info_title");

    const desc = $.CreatePanel("Label", textWrap, "");
    desc.AddClass("QuestInfoBlockDesc");
    desc.text = $.Localize("#quest_info_desc").replace("{time}", GetQuestTimeText());
}

InitQuests();