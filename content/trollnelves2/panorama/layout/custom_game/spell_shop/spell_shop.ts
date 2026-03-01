// @ts-nocheck
"use strict";

var activate_cooldown = false;
var buy_cooldown = false;
var CURRENT_SPELL_SELECTED = null;
var players_activated_spells = CustomNetTables.GetTableValue("game_spells_lib", "spell_active");
var CURRENT_SELECT_UNIT = null;
var SPELLS_TEXTURE = {};
var player_table: any = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
var active_shop = null;

function SpellShop_InitSpellPanel() {
    const minimap_container = FindDotaHudElement("minimap_container");
    const SpellMapPanel = $("#SpellMapPanel");
    if (SpellMapPanel) {
        if (minimap_container.FindChildTraverse("SpellMapPanel")) {
            SpellMapPanel.DeleteAsync(0);
        } else {
            SpellMapPanel.SetParent(minimap_container);
        }
    }
    const GlyphScanContainer = FindDotaHudElement("GlyphScanContainer");
    if (GlyphScanContainer) {
        GlyphScanContainer.style.visibility = "collapse";
    }
    SpellShop_InitSpellList();
    // UpdateBuyButton() -- remove buy random aspect
}

function UpdateActivatedSpellVisual() {
    for (const child of $("#SpellShopSpellsListBody").Children()) {
        child.SetHasClass("IsActivatedSpell", SpellShop_IsSpellActivate(child.spell_id));
    }
}

function SpellShop_InitSpellList() {
    $("#SpellShopSpellsListBody").RemoveAndDeleteChildren();
    const spell_cost = CustomNetTables.GetTableValue("game_spells_lib", "spell_cost");
    if (spell_cost) {
        // $("#UnlockPanelBuyButtonCostLabel").text = spell_cost.cost // remove buy random aspect
    }
    const game_spells_lib = CustomNetTables.GetTableValue("game_spells_lib", "spell_list");
    for (let i = 0; i <= Object.keys(game_spells_lib).length; i++) {
        if (game_spells_lib[i] && game_spells_lib[i][6] == active_shop) {
            SpellShop_CreateSpell(game_spells_lib[i]);
        }
    }
}

function SpellShop_CreateSpell(info) {
    const spell_player_level = SpellShop_GetPlayerSpellLevel(info[1], true);

    const SpellShopSpellPanel = $.CreatePanel("Panel", $("#SpellShopSpellsListBody"), "");
    SpellShopSpellPanel.AddClass("SpellShopSpellPanel");
    SpellShopSpellPanel.spell_id = info[1];

    const SpellShopSpellPanel_Body = $.CreatePanel("Panel", SpellShopSpellPanel, "");
    SpellShopSpellPanel_Body.AddClass("SpellShopSpellPanel_Body");

    const SpellShopSpellPanelIcon = $.CreatePanel("Panel", SpellShopSpellPanel_Body, "");
    SpellShopSpellPanelIcon.AddClass("SpellShopSpellPanelIcon");
    SpellShopSpellPanelIcon.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + SpellShop_GetSpellTexture(info[1], spell_player_level) + '.png")';
    SpellShopSpellPanelIcon.style.backgroundSize = "100%";

    const SpellShopSpell_counter = $.CreatePanel("Panel", SpellShopSpellPanel, "");
    SpellShopSpell_counter.AddClass("SpellShopSpell_counter");

    const SpellShopSpell_counter_glow = $.CreatePanel("Panel", SpellShopSpell_counter, "");
    SpellShopSpell_counter_glow.AddClass("SpellShopSpell_counter_glow");

    const SpellShopSpell_counter_label = $.CreatePanel("Label", SpellShopSpell_counter, "");
    SpellShopSpell_counter_label.AddClass("SpellShopSpell_counter_label");
    SpellShopSpell_counter_label.text = spell_player_level;

    if (spell_player_level <= 1) {
        SpellShopSpell_counter.visible = false;
    }

    if (SpellShop_PlayerHasSpell(info[1])) {
        SpellShopSpellPanelIcon.SetHasClass("SpellDisabled", false);
    } else {
        SpellShopSpellPanelIcon.SetHasClass("SpellDisabled", true);
    }
    // Отключаем перк, если он не доступен в этом режиме.
    if (info[7] != "1") {
        SpellShopSpellPanelIcon.SetHasClass("SpellDisabled", true);
    }

    SpellShop_SetActiveSpellPreview(SpellShopSpellPanel, info);
}

function SpellShop_PlayerHasSpell(spell) {
    if (player_table) {
        for (const id in player_table) {
            if (player_table[id]) {
                if (player_table[id][1] == spell) {
                    return true;
                }
            }
        }
    }
    return false;
}

function SpellShop_SetActiveSpellPreview(panel, info) {
    panel.SetPanelEvent("onactivate", function () {
        Game.EmitSound("General.ButtonClick");
        SpellShop_UpdatePreviewSpell(panel, info);
    });
}

function SpellShop_UpdatePreviewSpell(panel, info) {
    for (let i = 0; i < $("#SpellShopSpellsListBody").GetChildCount(); i++) {
        const panel_old = $("#SpellShopSpellsListBody").GetChild(i);
        if (panel_old) {
            panel_old.SetHasClass("SelectedSpellPrew", false);
        }
    }
    CURRENT_SPELL_SELECTED = info;
    panel.SetHasClass("SelectedSpellPrew", true);
    SpellShop_UpdatePreviewSpellInf(info);
}

function SpellShop_UpdatePreviewSpellInf(info) {
    $("#PreviewSpellInfo").RemoveAndDeleteChildren();

    const SpellShopInfoHeaderLabel = $.CreatePanel("Label", $("#PreviewSpellInfo"), "");
    SpellShopInfoHeaderLabel.AddClass("SpellShopInfoHeaderLabel");
    SpellShopInfoHeaderLabel.text = $.Localize("#spell_shop_header_inf");

    const SpellShopIconAndButton = $.CreatePanel("Panel", $("#PreviewSpellInfo"), "");
    SpellShopIconAndButton.AddClass("SpellShopIconAndButton");

    const SpellShopPreviewIcon = $.CreatePanel("Panel", SpellShopIconAndButton, "");
    SpellShopPreviewIcon.AddClass("SpellShopPreviewIcon");

    const SpellShopSpellPanelIcon = $.CreatePanel("Panel", SpellShopPreviewIcon, "");
    SpellShopSpellPanelIcon.AddClass("SpellShopSpellPanelIcon");
    SpellShopSpellPanelIcon.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + SpellShop_GetSpellTexture(info[1], SpellShop_GetPlayerSpellLevel(info[1], true)) + '.png")';
    SpellShopSpellPanelIcon.style.backgroundSize = "100%";

    const SpellPreviewPanelNameButton = $.CreatePanel("Panel", SpellShopIconAndButton, "");
    SpellPreviewPanelNameButton.AddClass("SpellPreviewPanelNameButton");

    const SpellPreviewPanelNameLabel = $.CreatePanel("Label", SpellPreviewPanelNameButton, "");
    SpellPreviewPanelNameLabel.AddClass("SpellPreviewPanelNameLabel");
    SpellPreviewPanelNameLabel.text = $.Localize("#" + info[1]);

    const SpellPreviewPanelNameLabelDesc = $.CreatePanel("Label", SpellPreviewPanelNameButton, "");
    SpellPreviewPanelNameLabelDesc.AddClass("SpellPreviewPanelNameLabelDesc");
    SpellPreviewPanelNameLabelDesc.text = $.Localize("#" + info[1] + "_description");

    const SpellBonusesPanel = $.CreatePanel("Panel", $("#PreviewSpellInfo"), "");
    SpellBonusesPanel.AddClass("SpellBonusesPanel");

    let SpellColumnBonus = $.CreatePanel("Panel", SpellBonusesPanel, "");
    SpellColumnBonus.AddClass("SpellColumnBonus");
    SpellColumnBonus.AddClass("SpellColumnBonus_name");

    for (var i = 0; i <= Object.keys(info[4]).length; i++) {
        if (info[4][i]) {
            const SpellPreviewLevelLabelDesc = $.CreatePanel("Label", SpellColumnBonus, "");
            SpellPreviewLevelLabelDesc.AddClass("SpellPreviewLevelLabelDesc");
            SpellPreviewLevelLabelDesc.html = true;
            SpellPreviewLevelLabelDesc.text = $.Localize("#" + info[4][i]);
        }
    }

    for (var i = 1; i <= 3; i++) {
        SpellColumnBonus = $.CreatePanel("Panel", SpellBonusesPanel, "SpellColumnBonus_" + i);
        SpellColumnBonus.AddClass("SpellColumnBonus");
        SpellColumnBonus.AddClass("SpellColumnBonus_" + i);
        if (SpellShop_GetPlayerSpellLevel(info[1]) == i) {
            SpellColumnBonus.AddClass("IsActiveColumn");
        }
        const SpellPreviewLevelLabel = $.CreatePanel("Label", SpellColumnBonus, "");
        SpellPreviewLevelLabel.AddClass("SpellPreviewLevelLabel");
        SpellPreviewLevelLabel.html = true;
        SpellPreviewLevelLabel.text = $.Localize("#SpellShop_SpellPreviewUpgrade") + " " + i;
    }

    for (var i = 1; i <= Object.keys(info[5]).length; i++) {
        for (let d = 1; d <= Object.keys(info[5][i]).length; d++) {
            const SpellColumnBonus_panel = SpellBonusesPanel.FindChildTraverse("SpellColumnBonus_" + d);
            if (SpellColumnBonus_panel) {
                const SpellPreviewLevelLabelValue = $.CreatePanel("Label", SpellColumnBonus_panel, "");
                SpellPreviewLevelLabelValue.AddClass("SpellPreviewLevelLabelValue");
                SpellPreviewLevelLabelValue.html = true;
                SpellPreviewLevelLabelValue.text = info[5][i][d];
            }
        }
    }

    const SpellPreviewPanelButtonActivate = $.CreatePanel("Panel", $("#PreviewSpellInfo"), "");
    SpellPreviewPanelButtonActivate.AddClass("SpellPreviewPanelButtonActivate");

    const SpellPreviewPanelButtonActivateLabel = $.CreatePanel("Label", SpellPreviewPanelButtonActivate, "");
    SpellPreviewPanelButtonActivateLabel.AddClass("SpellPreviewPanelButtonActivateLabel");

    const hero = Players.GetPlayerSelectedHero(Players.GetLocalPlayer());

    const SpellPreviewPanelButtonUpgrade = $.CreatePanel("Panel", SpellPreviewPanelNameButton, "");
    SpellPreviewPanelButtonUpgrade.AddClass("SpellPreviewPanelButtonUpgrade");
    const SpellPreviewPanelButtonUpgradeLabel = $.CreatePanel("Label", SpellPreviewPanelButtonUpgrade, "");
    SpellPreviewPanelButtonUpgradeLabel.AddClass("SpellPreviewPanelButtonUpgradeLabel");
    SpellPreviewPanelButtonUpgradeLabel.text = $.Localize("#SpellShop_Upgrade");
    const SpellPreviewPanelButtonUpgradeCost = $.CreatePanel("Panel", SpellPreviewPanelButtonUpgrade, "");
    SpellPreviewPanelButtonUpgradeCost.AddClass("SpellPreviewPanelButtonCost");
    const SpellPreviewPanelButtonUpgradeCostIcon = $.CreatePanel("Panel", SpellPreviewPanelButtonUpgradeCost, "");
    SpellPreviewPanelButtonUpgradeCostIcon.AddClass("SpellPreviewPanelButtonCostIcon");
    const SpellPreviewPanelButtonUpgradeCostLabel = $.CreatePanel("Label", SpellPreviewPanelButtonUpgradeCost, "");
    SpellPreviewPanelButtonUpgradeCostLabel.AddClass("SpellPreviewPanelButtonCostLabel");
    const nextLvlCost = SpellShop_GetSpellCost(info[1], SpellShop_GetPlayerSpellLevel(info[1]) + 1);
    SpellPreviewPanelButtonUpgradeCostLabel.text = nextLvlCost;
    const player_coins = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["0"]["1"];
    SpellShop_SetUpgradeSpell(SpellPreviewPanelButtonUpgrade, info);

    if (SpellShop_GetPlayerSpellLevel(info[1]) == 0) {
        SpellPreviewPanelButtonUpgrade.visible = false;
    }
    if (SpellShop_GetPlayerSpellLevel(info[1]) >= 3) {
        SpellPreviewPanelButtonUpgrade.visible = false;
    }

    if (nextLvlCost > player_coins) {
        SpellPreviewPanelButtonUpgrade.SetHasClass("BuyButtonDeactivate", true);
    } else {
        SpellPreviewPanelButtonUpgrade.SetHasClass("BuyButtonDeactivate", false);
    }

    if (SpellShop_PlayerHasSpell(info[1]) && ((active_shop == 0 && hero == "npc_dota_hero_treant") || (active_shop == 1 && hero == "npc_dota_hero_troll_warlord")) && info[7] == "1") {
        if (SpellShop_IsSpellActivate(info[1])) {
            SpellPreviewPanelButtonActivateLabel.text = $.Localize("#SpellShop_Deactivate");
            SpellPreviewPanelButtonActivate.AddClass("SpellPreviewPanelButtonDeactivate");
        } else {
            // SpellPreviewPanelButtonActivateLabel.text = $.Localize("#SpellShop_Activate")
            SpellPreviewPanelButtonActivateLabel.text = $.Localize("#SpellShop_no_buying_spell");
            SpellPreviewPanelButtonActivate.AddClass("SpellDisabled");
        }
        SpellShop_SetActivateSpell(SpellPreviewPanelButtonActivate, info);
    } else {
        SpellPreviewPanelButtonActivateLabel.text = $.Localize("#SpellShop_no_buying_spell");
        SpellPreviewPanelButtonActivate.AddClass("SpellDisabled");
    }

    player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
    let srok = "";
    if (player_table) {
        for (const id in player_table) {
            if (player_table[id]) {
                if (player_table[id][1] == info[1]) {
                    srok = player_table[id][3];
                    break;
                }
            }
        }
    }
    if (srok != "" && srok != null) {
        const SpellSrokPanelNameLabel = $.CreatePanel("Label", SpellPreviewPanelNameButton, "");
        SpellSrokPanelNameLabel.AddClass("SpellSrokPanelNameLabel");
        SpellSrokPanelNameLabel.text = $.Localize("#shop_trollchance_date") + srok;
    }
}

function SpellShop_SetActivateSpell(panel, info) {
    panel.SetPanelEvent("onactivate", function () {
        Game.EmitSound("General.ButtonClick");
        SpellShop_ActivateSpell(info);
    });
}

function SpellShop_ActivateSpell(info) {
    if (activate_cooldown) {
        return;
    }
    $.Schedule(0.25, function () {
        activate_cooldown = false;
    });
    activate_cooldown = true;
    const hero = Players.GetPlayerSelectedHero(Players.GetLocalPlayer());
    if (SpellShop_PlayerHasSpell(info[1]) && ((active_shop == 0 && hero == "npc_dota_hero_treant") || (active_shop == 1 && hero == "npc_dota_hero_troll_warlord"))) {
        GameEvents.SendCustomGameEventToServer("event_set_activate_spell", { spell_name: info[1], modifier_name: info[3] });
    }
    UpdateActivatedSpellVisual();
}

function SpellShop_SetUpgradeSpell(panel, info) {
    panel.SetPanelEvent("onactivate", function () {
        Game.EmitSound("General.ButtonClick");
        SpellShop_UpgradeSpell(info);
    });
}

function SpellShop_UpgradeSpell(info) {
    if (buy_cooldown) {
        return;
    }
    if (SpellShop_GetPlayerSpellLevel(info[1]) >= 3) {
        return;
    }
    $.Schedule(0.25, function () {
        buy_cooldown = false;
    });
    buy_cooldown = true;
    GameEvents.SendCustomGameEventToServer("event_upgrade_spell", { spell_name: info[1] });
}

function SpellShop_OpenSpellShop() {
    if (active_shop == 0) {
        $("#SpellShopPanel").SetHasClass("CloseSpellShop", true);
        active_shop = null;
    } else {
        active_shop = 0;
        $("#SpellShopPanel").SetHasClass("CloseSpellShop", false); // !$("#SpellShopPanel").BHasClass("CloseSpellShop")
        SpellShop_InitSpellList();
        // UpdateBuyButton() -- remove buy random aspect
        UpdateActivatedSpellVisual();
    }
}

function SpellShop_OpenSpellShoTroll() {
    if (active_shop == 1) {
        $("#SpellShopPanel").SetHasClass("CloseSpellShop", true);
        active_shop = null;
    } else {
        active_shop = 1;
        $("#SpellShopPanel").SetHasClass("CloseSpellShop", false); // !$("#SpellShopPanel").BHasClass("CloseSpellShop")
        SpellShop_InitSpellList();
        // UpdateBuyButton() -- remove buy random aspect
    }
}

function SpellShop_CloseSpellShop() {
    $("#SpellShopPanel").SetHasClass("CloseSpellShop", true); // !$("#SpellShopPanel").BHasClass("CloseSpellShop")
    active_shop = null;
}

CustomNetTables.SubscribeNetTableListener("game_spells_lib", SpellShop_UpdateSpellsLibTable);
CustomNetTables.SubscribeNetTableListener("Shop", SpellShop_UpdateItem);

function SpellShop_UpdateSpellsLibTable(table, key, data) {
    if (table == "game_spells_lib") {
        if (key == "spell_active") {
            SpellShop_UpdateCurrentSpells(data);
            UpdateActivatedSpellVisual();
        }
        //   if (key == String(Players.GetLocalPlayer()))
        //    {
        //        player_table = CustomNetTables.GetTableValue("game_spells_lib", String(Players.GetLocalPlayer()))
        //        UpdateBuyButton() -- remove buy random aspect
        //        SpellShop_UpdateHasSpells()
        //    }
    }
}

function SpellShop_UpdateItem(table, key, data) {
    if (table == "Shop") {
        if (key == String(Players.GetLocalPlayer())) {
            player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
            // UpdateBuyButton() -- remove buy random aspect
            SpellShop_UpdateHasSpells();
        }
    }
}

function SpellShop_IsSpellActivate(spell_name) {
    const player_id = Players.GetLocalPlayer();
    const active_table = CustomNetTables.GetTableValue("game_spells_lib", "spell_active");
    if (active_table) {
        if (active_table[player_id]) {
            for (let i = 0; i <= Object.keys(active_table[player_id]).length; i++) {
                if (active_table[player_id][i] && active_table[player_id][i] == spell_name) {
                    return true;
                }
            }
        }
    }
    return false;
}

function SpellShop_GetPlayerSpellLevel(spell_name, texture?) {
    player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
    if (player_table) {
        for (const id in player_table) {
            if (player_table[id]) {
                if (player_table[id][1] == spell_name) {
                    return player_table[id][2];
                }
            }
        }
    }
    if (texture) {
        return 1;
    }
    return 0;
}

function SpellShop_GetSelectedPlayerSpellLevel(spell_name, id) {
    const current_target_table = CustomNetTables.GetTableValue("Shop", id)["12"];
    if (current_target_table) {
        for (var id in current_target_table) {
            if (current_target_table[id]) {
                if (current_target_table[id][1] == spell_name) {
                    return current_target_table[id][2];
                }
            }
        }
    }
    return 0;
}

function SpellShop_UpdateCurrentSpells(data) {
    if (CURRENT_SPELL_SELECTED != null) {
        SpellShop_UpdatePreviewSpellInf(CURRENT_SPELL_SELECTED);
    }
    players_activated_spells = data;
}

function SpellShop_GetSpellTexture(spell_name, any_level) {
    if (any_level == null) {
        any_level = 1;
    }
    if (SPELLS_TEXTURE[spell_name + "_" + any_level]) {
        return SPELLS_TEXTURE[spell_name + "_" + any_level];
    }
    const game_spells_lib = CustomNetTables.GetTableValue("game_spells_lib", "spell_list");
    for (let i = 0; i <= Object.keys(game_spells_lib).length; i++) {
        if (game_spells_lib[i] && game_spells_lib[i][1] == spell_name) {
            return game_spells_lib[i][2]; // + "_" + any_level
        }
    }
}

function GetSpellName(spell_name) {
    const game_spells_lib = CustomNetTables.GetTableValue("game_spells_lib", "spell_list");
    for (let i = 0; i <= Object.keys(game_spells_lib).length; i++) {
        if (game_spells_lib[i] && game_spells_lib[i][1] == spell_name) {
            return game_spells_lib[i][1]; // + "_" + any_level
        }
    }
}

function GetSpellModifier(spell_name) {
    const game_spells_lib = CustomNetTables.GetTableValue("game_spells_lib", "spell_list");
    for (let i = 0; i <= Object.keys(game_spells_lib).length; i++) {
        if (game_spells_lib[i] && game_spells_lib[i][1] == spell_name) {
            return game_spells_lib[i][3]; // + "_" + any_level
        }
    }
}

function SpellShop_GetSpellCost(spell_name, level) {
    const shop = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer());
    if (!shop || !shop["12"] || !shop["18"]) {
        return 0;
    }

    const spells = shop["12"];
    const costs = shop["18"];

    const game_spells_lib = CustomNetTables.GetTableValue("game_spells_lib", "spell_list");
    for (const i in spells) {
        if (spells[i] && spells[i][1] == spell_name) {
            const side = game_spells_lib[i] ? game_spells_lib[i][6] : "0";
            if (costs[side]) {
                return costs[side][i] || 0;
            }
            return 0;
        }
    }
    return 0;
}

function SpellShop_SetShowText(panel, text, spell, level) {
    panel.SetPanelEvent("onmouseover", function () {
        $.DispatchEvent("DOTAShowTextTooltip", panel, "<b>" + $.Localize("#" + spell) + " " + level + "</b><br>" + $.Localize("#" + text));
    });

    panel.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideTextTooltip", panel);
    });
}

function SpellShop_RemoveText(panel, text) {
    panel.SetPanelEvent("onmouseover", function () {});
    panel.SetPanelEvent("onmouseout", function () {
        $.DispatchEvent("DOTAHideTextTooltip", panel);
    });
}

// remove buy random aspect
/*
function SpellShop_BuyRandomSpell()
{
    if (SpellShop_CheckBuyAllSpells())
    {
        return
    }
    if (buy_cooldown)
    {
        return
    }
    $.Schedule(0.25, function()
    {
        buy_cooldown = false
    })
    let spell_cost = CustomNetTables.GetTableValue("game_spells_lib", "spell_cost")
    let player_table_coins = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["0"]["1"];
    if (player_table_coins && spell_cost)
    {
        if (player_table_coins && player_table_coins >= spell_cost.cost)
        {
            buy_cooldown = true
            GameEvents.SendCustomGameEventToServer( "event_buy_spell", {idPerk: active_shop} );
        }
    }
}

function UpdateBuyButton()
{
    if (SpellShop_CheckBuyAllSpells())
    {
        $("#UnlockPanelBuyButton").SetHasClass("BuyButtonDeactivate", true)
        return
    }
    let spell_cost = CustomNetTables.GetTableValue("game_spells_lib", "spell_cost")
    let player_table_coins = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["0"]["1"];
    if (player_table_coins && spell_cost)
    {
        if (player_table_coins && player_table_coins >= spell_cost.cost)
        {
            $("#UnlockPanelBuyButton").SetHasClass("BuyButtonDeactivate", false)
            return
        }
    }
    $("#UnlockPanelBuyButton").SetHasClass("BuyButtonDeactivate", true)
}
*/

function SpellShop_UpdateHasSpells() {
    $("#PreviewSpellInfo").RemoveAndDeleteChildren();
    SpellShop_InitSpellList();
}

function SpellShop_SpellDropNotification(data) {
    const panel_spell_drop = $.CreatePanel("Panel", $.GetContextPanel(), "");
    panel_spell_drop.AddClass("panel_spell_drop");

    const panel_spell_drop_bg = $.CreatePanel("Panel", panel_spell_drop, "");
    panel_spell_drop_bg.AddClass("panel_spell_drop_bg");

    const panel_spell_drop_main = $.CreatePanel("Panel", panel_spell_drop, "");
    panel_spell_drop_main.AddClass("panel_spell_drop_main");

    const panel_spell_drop_label_header = $.CreatePanel("Label", panel_spell_drop_main, "");
    panel_spell_drop_label_header.AddClass("panel_spell_drop_label_header");
    panel_spell_drop_label_header.text = $.Localize("#SpellShop_DropHeader");

    if (data.upgrade) {
        panel_spell_drop_label_header.text = $.Localize("#SpellShop_DropHeader_upgrade");
    }

    const SpellShopSpellPanel = $.CreatePanel("Panel", panel_spell_drop_main, "");
    SpellShopSpellPanel.AddClass("SpellShopSpellPanelDrop");

    const SpellShopSpellPanelIcon = $.CreatePanel("Panel", SpellShopSpellPanel, "");
    SpellShopSpellPanelIcon.AddClass("SpellShopSpellPanelIconDrop");

    if (data.upgrade) {
        SpellShopSpellPanelIcon.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + SpellShop_GetSpellTexture(data.spell_name, data.upgrade) + '.png")';
        SpellShopSpellPanelIcon.style.backgroundSize = "100%";
    } else {
        SpellShopSpellPanelIcon.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + SpellShop_GetSpellTexture(data.spell_name) + '.png")';
        SpellShopSpellPanelIcon.style.backgroundSize = "100%";
    }

    const panel_label_spell_name_drop = $.CreatePanel("Label", panel_spell_drop_main, "");
    panel_label_spell_name_drop.AddClass("panel_label_spell_name_drop");
    panel_label_spell_name_drop.text = $.Localize("#" + data.spell_name);

    if (data.upgrade) {
        panel_label_spell_name_drop.text = $.Localize("#" + data.spell_name) + " " + data.upgrade;
    }

    const SpellShopButtonDropClose = $.CreatePanel("Panel", panel_spell_drop_main, "");
    SpellShopButtonDropClose.AddClass("SpellShopButtonDropClose");

    const SpellShopButtonDropCloseLabel = $.CreatePanel("Label", SpellShopButtonDropClose, "");
    SpellShopButtonDropCloseLabel.AddClass("SpellShopButtonDropCloseLabel");
    SpellShopButtonDropCloseLabel.text = $.Localize("#SpellShop_DropClose");

    Game.EmitSound("ui_item_gifted");

    SpellShopButtonDropClose.SetPanelEvent("onactivate", function () {
        panel_spell_drop.style.opacity = "0";
        panel_spell_drop.DeleteAsync(1);
    });
}

function SpellShop_CheckBuyAllSpells() {
    let counts_spell = 0;
    const count_spell_player = 0;
    let all_spells_player_has_max_level = true;
    const game_spells_lib = CustomNetTables.GetTableValue("game_spells_lib", "spell_list");
    const perkInShop = [];
    for (var i = 0; i <= Object.keys(game_spells_lib).length; i++) {
        if (game_spells_lib[i] && game_spells_lib[i][6] == active_shop) {
            counts_spell = counts_spell + 1;
            perkInShop[perkInShop.length + 1] = game_spells_lib[i][1];
        }
    }
    player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
    if (player_table) {
        for (const id in player_table) {
            if (player_table[id][1]) {
                for (var i = 0; i <= perkInShop.length; i++) {
                    if (player_table[id][2] < 3 && player_table[id][1] == perkInShop[i]) {
                        // $.Msg(player_table[id][2])
                        // $.Msg(player_table[id])
                        all_spells_player_has_max_level = false;
                    }
                }
            }
        }
    }
    if (all_spells_player_has_max_level) {
        return true;
    }
    return false;
}

function UpdateVisualSelectedSpells() {
    const selected_unit = Players.GetLocalPlayerPortraitUnit();
    if (!selected_unit || !Entities.IsHero(selected_unit) || selected_unit == -1) {
        return;
    }
    const panel_minimap_hud = FindDotaHudElement("minimap_container");
    const player_id = Entities.GetPlayerOwnerID(selected_unit);
    const active_table = players_activated_spells;
    if (Game.IsInToolsMode()) {
        $.Msg("Смена игрока выбранного id - ", player_id);
    }
    for (let i = 1; i <= 3; i++) {
        const ActivatedSpellIcon = panel_minimap_hud.FindChildTraverse("ActivatedSpellIcon" + i);
        if (!ActivatedSpellIcon) {
            continue;
        }
        if (active_table[player_id] && active_table[player_id][i] && active_table[player_id][i] != "") {
            const spellName = GetSpellName(active_table[player_id][i]);
            const spellLevel = SpellShop_GetSelectedPlayerSpellLevel(active_table[player_id][i], player_id);
            const spellTexture = SpellShop_GetSpellTexture(spellName, spellLevel);
            ActivatedSpellIcon.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + spellTexture + '.png")';
            ActivatedSpellIcon.style.backgroundSize = "100%";
            SpellShop_SetShowText(ActivatedSpellIcon, GetSpellModifier(active_table[player_id][i]) + "_description_level_" + spellLevel, active_table[player_id][i], spellLevel);
        } else {
            ActivatedSpellIcon.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/no_active2.png")';
            ActivatedSpellIcon.style.backgroundSize = "100%";
            SpellShop_RemoveText(ActivatedSpellIcon, "");
        }
    }
}

GameEvents.Subscribe("dota_player_update_selected_unit", UpdateVisualSelectedSpells);
GameEvents.Subscribe("dota_player_update_query_unit", UpdateVisualSelectedSpells);
GameEvents.Subscribe("m_event_dota_inventory_changed_query_unit", UpdateVisualSelectedSpells);
GameEvents.SubscribeProtected("event_spell_shop_drop", SpellShop_SpellDropNotification);
GameEvents.SubscribeProtected("Shop", SpellShop_SpellDropNotification);
SpellShop_InitSpellPanel();
