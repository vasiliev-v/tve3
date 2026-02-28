"use strict";

var activate_cooldown = false
var buy_cooldown = false
var CURRENT_SPELL_SELECTED = null
var players_activated_spells = CustomNetTables.GetTableValue("game_spells_lib", "spell_active")
var CURRENT_SELECT_UNIT = null
var SPELLS_TEXTURE = {}
var player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
var active_shop = null

function SpellTemple_InitSpellPanel()
{
    SpellTemple_InitSpellList()
}

function SpellTemple_GetDotaHud()
{
	let hPanel = $.GetContextPanel();

	while ( hPanel && hPanel.id !== 'Hud')
	{
        hPanel = hPanel.GetParent();
	}

	if (!hPanel)
	{
        throw new Error('Could not find Hud root from panel with id: ' + $.GetContextPanel().id);
	}

	return hPanel;
}

function SpellTemple_InitSpellList()
{
    $("#SpellShopSpellsListBody").RemoveAndDeleteChildren()
    let spell_cost = CustomNetTables.GetTableValue("game_spells_lib", "spell_cost")
    if (spell_cost)
    {
        // $("#UnlockPanelBuyButtonCostLabel").text = spell_cost.cost // remove buy random aspect
    }
    let game_spells_lib = CustomNetTables.GetTableValue("game_spells_lib", "spell_list")
    for (var i = 0; i <= Object.keys(game_spells_lib).length; i++)
    {
        if (game_spells_lib[i] && game_spells_lib[i][5] == active_shop)
        {
            SpellTemple_CreateSpell(game_spells_lib[i])
        }
    }
}

function SpellTemple_CreateSpell(info) 
{
    let SpellShopSpellPanel = $.CreatePanel("Panel", $("#SpellShopSpellsListBody"), "")
    SpellShopSpellPanel.AddClass("SpellShopSpellPanel")
    let SpellShopSpellPanelIcon = $.CreatePanel("Panel", SpellShopSpellPanel, "")
    SpellShopSpellPanelIcon.AddClass("SpellShopSpellPanelIcon")
    SpellShopSpellPanelIcon.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + SpellTemple_GetSpellTexture(info[1], SpellTemple_GetPlayerSpellLevel(info[1], true)) + '.png")';
    SpellShopSpellPanelIcon.style.backgroundSize = "100%"
    let SpellShopSpellBorder = $.CreatePanel("Panel", SpellShopSpellPanel, "")
    SpellShopSpellBorder.AddClass("SpellShopSpellBorder")

    if (SpellTemple_PlayerHasSpell(info[1]))
    {
        SpellShopSpellPanelIcon.SetHasClass("SpellDisabled", false)
    }
    else
    {
        SpellShopSpellPanelIcon.SetHasClass("SpellDisabled", true)
    }

    SpellTemple_SetActiveSpellPreview(SpellShopSpellPanel, info)
}

function SpellTemple_PlayerHasSpell(spell)
{
    if (player_table)
    {
        for ( var id in player_table)
        {
            if (player_table[id])
            {
                if (player_table[id][1] == spell)
                {
                    return true
                }
            }
        }
    }
    return false
}

function SpellTemple_SetActiveSpellPreview(panel, info)
{
    panel.SetPanelEvent("onactivate", function() 
    { 
        Game.EmitSound("General.ButtonClick")
        SpellTemple_UpdatePreviewSpell(panel, info)
    });
}

function SpellTemple_UpdatePreviewSpell(panel, info)
{
    for (var i = 0; i < $("#SpellShopSpellsListBody").GetChildCount(); i++) 
    {
        let panel_old = $("#SpellShopSpellsListBody").GetChild(i)
        if (panel_old)
        {
            panel_old.SetHasClass("SelectedSpellPrew", false)
        }
    }
    CURRENT_SPELL_SELECTED = info
    panel.SetHasClass("SelectedSpellPrew", true)
    SpellTemple_UpdatePreviewSpellInf(info)
}

function SpellTemple_UpdatePreviewSpellInf(info)
{
    $("#PreviewSpellInfo").RemoveAndDeleteChildren()
    let SpellShopIconAndButton = $.CreatePanel("Panel", $("#PreviewSpellInfo"), "")
    SpellShopIconAndButton.AddClass("SpellShopIconAndButton")
    let SpellShopPreviewIcon = $.CreatePanel("Panel", SpellShopIconAndButton, "")
    SpellShopPreviewIcon.AddClass("SpellShopPreviewIcon")
    let SpellShopPreviewEffect = $.CreatePanel("Panel", SpellShopPreviewIcon, "")
    SpellShopPreviewEffect.AddClass("SpellShopPreviewEffect")
    let SpellShopSpellPanelIcon = $.CreatePanel("Panel", SpellShopPreviewIcon, "")
    SpellShopSpellPanelIcon.AddClass("SpellShopSpellPanelIcon")
    SpellShopSpellPanelIcon.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + SpellTemple_GetSpellTexture(info[1], SpellTemple_GetPlayerSpellLevel(info[1], true)) + '.png")';
    SpellShopSpellPanelIcon.style.backgroundSize = "100%"
    let SpellShopSpellBorder = $.CreatePanel("Panel", SpellShopPreviewIcon, "")
    SpellShopSpellBorder.AddClass("SpellShopSpellBorder")
    let SpellPreviewPanelNameButton = $.CreatePanel("Panel", SpellShopIconAndButton, "")
    SpellPreviewPanelNameButton.AddClass("SpellPreviewPanelNameButton")
    let SpellPreviewPanelNameLabel = $.CreatePanel("Label", SpellPreviewPanelNameButton, "")
    SpellPreviewPanelNameLabel.AddClass("SpellPreviewPanelNameLabel")
    SpellPreviewPanelNameLabel.text = $.Localize("#" + info[1])
    let SpellPreviewPanelButtonActivate = $.CreatePanel("Panel", SpellPreviewPanelNameButton, "")
    SpellPreviewPanelButtonActivate.AddClass("SpellPreviewPanelButtonActivate")
    let SpellPreviewPanelButtonActivateLabel = $.CreatePanel("Label", SpellPreviewPanelButtonActivate, "")
    SpellPreviewPanelButtonActivateLabel.AddClass("SpellPreviewPanelButtonActivateLabel")

    var hero = Players.GetPlayerSelectedHero(Players.GetLocalPlayer());


    SpellPreviewPanelButtonActivateLabel.text = $.Localize("#SpellShop_Buy")
    SpellPreviewPanelButtonActivate.AddClass("SpellPreviewPanelButtonActivate")
    SpellTemple_SetActivateSpell(SpellPreviewPanelButtonActivate, info)

    let SpellPreviewPanelButtonUpgrade = $.CreatePanel("Panel", SpellPreviewPanelNameButton, "")
    SpellPreviewPanelButtonUpgrade.AddClass("SpellPreviewPanelButtonActivate")
    let SpellPreviewPanelButtonUpgradeLabel = $.CreatePanel("Label", SpellPreviewPanelButtonUpgrade, "")
    SpellPreviewPanelButtonUpgradeLabel.AddClass("SpellPreviewPanelButtonActivateLabel")
    SpellPreviewPanelButtonUpgradeLabel.text = $.Localize("#SpellShop_Upgrade")
    SpellTemple_SetUpgradeSpell(SpellPreviewPanelButtonUpgrade, info)

    if (SpellTemple_GetPlayerSpellLevel(info[1]) == 0)
    {
        SpellPreviewPanelButtonUpgrade.visible = false
    }
    if (SpellTemple_GetPlayerSpellLevel(info[1]) >= 3)
    {
        SpellPreviewPanelButtonUpgrade.visible = false
    }

    if (SpellTemple_CheckBuyAllSpells())
    {
        SpellPreviewPanelButtonActivate.SetHasClass("BuyButtonDeactivate", true)
        return
    }
    let spell_cost = CustomNetTables.GetTableValue("game_spells_lib", "spell_cost")
    let player_table_coins = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["0"]["1"];
    if (player_table_coins && spell_cost)
    {
        if (player_table_coins && player_table_coins >= spell_cost.cost)
        {
            SpellPreviewPanelButtonActivateLabel.text = $.Localize("#SpellShop_Buy")
        }
        else
        {
            SpellPreviewPanelButtonActivate.SetHasClass("BuyButtonDeactivate", true)
            return
        }
    }
    

    for (var i = 0; i <= Object.keys(info[4]).length; i++)
    {
        if (info[4][i])
        {
            let SpellPreviewLevelLabel = $.CreatePanel("Label", $("#PreviewSpellInfo"), "")
            SpellPreviewLevelLabel.AddClass("SpellPreviewLevelLabel")
            SpellPreviewLevelLabel.html = true
            SpellPreviewLevelLabel.text = $.Localize("#SpellShop_SpellPreviewUpgrade") + " " + i
            if (SpellTemple_GetPlayerSpellLevel(info[1]) < i)
            {
                SpellPreviewLevelLabel.text = $.Localize("#SpellShop_SpellPreviewUpgrade") + " " + i + " <font color='red'>(" + $.Localize("#SpellShop_no_buying_spell") + ")</font>"
            }
            let SpellPreviewLevelLabelDesc = $.CreatePanel("Label", $("#PreviewSpellInfo"), "")
            SpellPreviewLevelLabelDesc.AddClass("SpellPreviewLevelLabelDesc")
            SpellPreviewLevelLabelDesc.text = $.Localize("#" + info[4][i])
            if (SpellTemple_GetPlayerSpellLevel(info[1]) >= 3)
            {
                SpellPreviewPanelButtonActivate.SetHasClass("BuyButtonDeactivate", true)
            }
        }
    }

    player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
    let srok = "";
    if (player_table)
    {
        for ( var id in player_table)
        {
            if (player_table[id])
            {
                if (player_table[id][1] == info[1])
                {
                    srok = player_table[id][3]
                    break
                }
            }
        }
    }
    if (srok != "" && srok != null)
    {
        let SpellSrokPanelNameLabel = $.CreatePanel("Label", SpellPreviewPanelNameButton, "")
        SpellSrokPanelNameLabel.AddClass("SpellSrokPanelNameLabel")
        SpellSrokPanelNameLabel.text = $.Localize("#shop_trollchance_date") + srok
    }

}

function SpellTemple_SetActivateSpell(panel, info)
{
    panel.SetPanelEvent("onactivate", function() 
    { 
        Game.EmitSound("General.ButtonClick")
        SpellTemple_ActivateSpell(info)
    });
}

function SpellTemple_ActivateSpell(info)
{
    if (SpellTemple_CheckBuyAllSpells())
    {
        return
    }
    if (buy_cooldown)
    {
        return
    }
    if (SpellTemple_GetPlayerSpellLevel(info[1]) >= 3)
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
            GameEvents.SendCustomGameEventToServer( "event_buy_spell", {idPerk: active_shop, info: info} );
        }
    }
} 

function SpellTemple_FindDotaHudElement(sId)
{
	return SpellTemple_GetDotaHud().FindChildTraverse(sId);
}

function SpellTemple_SetUpgradeSpell(panel, info)
{
    panel.SetPanelEvent("onactivate", function()
    {
        Game.EmitSound("General.ButtonClick")
        SpellTemple_UpgradeSpell(info)
    });
}

function SpellTemple_UpgradeSpell(info)
{
    if (buy_cooldown)
    {
        return
    }
    if (SpellTemple_GetPlayerSpellLevel(info[1]) >= 3)
    {
        return
    }
    $.Schedule(0.25, function()
    {
        buy_cooldown = false
    })
    let nextLvl = SpellTemple_GetPlayerSpellLevel(info[1]) + 1
    let cost = SpellTemple_GetSpellCost(info[1], nextLvl)
    let player_coins = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["0"]["1"]
    if (player_coins && cost && player_coins >= cost)
    {
        buy_cooldown = true
        GameEvents.SendCustomGameEventToServer("event_upgrade_spell", {spell_name: info[1]});
    }
}

function SpellTemple_OpenSpellShop()
{
    if(active_shop == 0)
    {
        $("#SpellShopPanel").SetHasClass("SpellTemple_CloseSpellShop", true) 
        active_shop = null
    }
    else
    {
        active_shop = 0
        $("#SpellShopPanel").SetHasClass("SpellTemple_CloseSpellShop", false) // !$("#SpellShopPanel").BHasClass("SpellTemple_CloseSpellShop")
        SpellTemple_InitSpellList()
    }
}

function SpellTemple_OpenSpellShoTroll()
{
    if(active_shop == 1)
    {
        $("#SpellShopPanel").SetHasClass("SpellTemple_CloseSpellShop", true) 
        active_shop = null
    }
    else
    {
        active_shop = 1
        $("#SpellShopPanel").SetHasClass("SpellTemple_CloseSpellShop", false) // !$("#SpellShopPanel").BHasClass("SpellTemple_CloseSpellShop")
        SpellTemple_InitSpellList()
    }
}

function SpellTemple_CloseSpellShop()
{
    $("#SpellShopPanel").SetHasClass("SpellTemple_CloseSpellShop",true ) // !$("#SpellShopPanel").BHasClass("SpellTemple_CloseSpellShop")
    active_shop = null
}

CustomNetTables.SubscribeNetTableListener( "game_spells_lib", SpellTemple_UpdateSpellsLibTable );
CustomNetTables.SubscribeNetTableListener( "Shop", SpellTemple_UpdateItem);

function SpellTemple_UpdateSpellsLibTable(table, key, data ) 
{
	if (table == "game_spells_lib") 
	{
		if (key == "spell_active") 
        {
            SpellTemple_UpdateCurrentSpells(data)
		}
	}
}

function SpellTemple_UpdateItem(table, key, data ) 
{
	if (table == "Shop") 
	{
        if (key == String(Players.GetLocalPlayer())) 
        {
            player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
            SpellTemple_UpdateHasSpells()
		}
	}
}

function SpellTemple_IsSpellActivate(spell_name)
{
    let player_id = Players.GetLocalPlayer()
    let active_table = CustomNetTables.GetTableValue("game_spells_lib", "spell_active")
    if (active_table)
    {
        if (active_table[player_id])
        {
            for (var i = 0; i <= Object.keys(active_table[player_id]).length; i++)
            {
                if (active_table[player_id][i] && active_table[player_id][i] == spell_name)
                {
                    return true
                }
            }
        }
    }
    return false
}

function SpellTemple_GetPlayerSpellLevel(spell_name, texture)
{
    player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
    if (player_table)
    {
        for ( var id in player_table)
        {
            if (player_table[id])
            {
                if (player_table[id][1] == spell_name)
                {
                    return player_table[id][2]
                }
            }
        }
    }
    if (texture)
    {
        return 1
    }
    return 0
}

function SpellTemple_GetSelectedPlayerSpellLevel(spell_name, id)
{
    if (player_table)
    {
        for ( var id in player_table)
        {
            if (player_table[id])
            {
                if (player_table[id][1] == spell_name)
                {
                    return player_table[id][2]
                }
            }
        }
    }
    return 0
}

function SpellTemple_UpdateCurrentSpells(data)
{
    if (CURRENT_SPELL_SELECTED != null)
    {
        SpellTemple_UpdatePreviewSpellInf(CURRENT_SPELL_SELECTED)
    }
    players_activated_spells = data
}

function SpellTemple_GetSpellTexture(spell_name, any_level)
{
    if (any_level == null)
    {
        any_level = 1
    }
    if (SPELLS_TEXTURE[spell_name + "_" + any_level])
    {
        return SPELLS_TEXTURE[spell_name + "_" + any_level]
    }
    let game_spells_lib = CustomNetTables.GetTableValue("game_spells_lib", "spell_list")
    for (var i = 0; i <= Object.keys(game_spells_lib).length; i++)
    {
        if (game_spells_lib[i] && game_spells_lib[i][1] == spell_name)
        {
            return game_spells_lib[i][2] + "_" + any_level
        }
    }
}

function SpellTemple_GetSpellCost(spell_name, level)
{
    let shop = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())
    if (!shop || !shop["12"] || !shop["18"]) return 0

    let spells = shop["12"]
    let costs = shop["18"]

    let game_spells_lib = CustomNetTables.GetTableValue("game_spells_lib", "spell_list")

    for (var i in spells)
    {
        if (spells[i] && spells[i][1] == spell_name)
        {
            let side = game_spells_lib[i] ? game_spells_lib[i][6] : "0"
            if (costs[side])
            {
                return costs[side][i] || 0
            }
            return 0
        }
    }
    return 0
}

function SpellTemple_SetShowText(panel, text, spell, level)
{
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', panel, "<b>" + $.Localize("#"+spell) + " " + level + "</b><br>" + $.Localize("#"+text)) });
        
    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });       
}

function SpellTemple_RemoveText(panel, text)
{
    panel.SetPanelEvent('onmouseover', function() 
    {
        
    });
    panel.SetPanelEvent('onmouseout', function() 
    {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });       
}

// remove buy random aspect
/*
function SpellTemple_BuyRandomSpell()
{
    if (SpellTemple_CheckBuyAllSpells())
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
*/

function SpellTemple_UpdateHasSpells()
{
    $("#PreviewSpellInfo").RemoveAndDeleteChildren()
    SpellTemple_InitSpellList()
}

function SpellTemple_SpellDropNotification(data)
{
    let panel_spell_drop = $.CreatePanel("Panel", $.GetContextPanel(), "")
    panel_spell_drop.AddClass("panel_spell_drop")
    let panel_spell_drop_label_header = $.CreatePanel("Label", panel_spell_drop, "")
    panel_spell_drop_label_header.AddClass("panel_spell_drop_label_header")
    panel_spell_drop_label_header.text = $.Localize("#SpellShop_DropHeader")
    if (data.upgrade)
    {
        panel_spell_drop_label_header.text = $.Localize("#SpellShop_DropHeader_upgrade")
    }
    let SpellShopSpellPanel = $.CreatePanel("Panel", panel_spell_drop, "")
    SpellShopSpellPanel.AddClass("SpellShopSpellPanelDrop")
    let SpellShopSpellPanelIcon = $.CreatePanel("Panel", SpellShopSpellPanel, "")
    SpellShopSpellPanelIcon.AddClass("SpellShopSpellPanelIconDrop")
    if (data.upgrade)
    {
        SpellShopSpellPanelIcon.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + SpellTemple_GetSpellTexture(data.spell_name, data.upgrade) + '.png")';
        SpellShopSpellPanelIcon.style.backgroundSize = "100%"
    }
    else
    {
        SpellShopSpellPanelIcon.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + SpellTemple_GetSpellTexture(data.spell_name) + '.png")';
        SpellShopSpellPanelIcon.style.backgroundSize = "100%"
    }
    let SpellShopSpellBorder = $.CreatePanel("Panel", SpellShopSpellPanel, "")
    SpellShopSpellBorder.AddClass("SpellShopSpellBorderDrop")
    let panel_label_spell_name_drop = $.CreatePanel("Label", panel_spell_drop, "")
    panel_label_spell_name_drop.AddClass("panel_label_spell_name_drop")
    panel_label_spell_name_drop.text = $.Localize("#"+data.spell_name)
    if (data.upgrade)
    {
        panel_label_spell_name_drop.text = $.Localize("#"+data.spell_name) + " " + data.upgrade
    }
    let SpellShopButtonDropClose = $.CreatePanel("Panel", panel_spell_drop, "")
    SpellShopButtonDropClose.AddClass("SpellShopButtonDropClose")
    let SpellShopButtonDropCloseLabel = $.CreatePanel("Label", SpellShopButtonDropClose, "")
    SpellShopButtonDropCloseLabel.AddClass("SpellShopButtonDropCloseLabel")
    SpellShopButtonDropCloseLabel.text = $.Localize("#SpellShop_DropClose")

    Game.EmitSound("ui_item_gifted")

    SpellShopButtonDropClose.SetPanelEvent("onactivate", function() 
    { 
        panel_spell_drop.style.opacity = "0"
        panel_spell_drop.DeleteAsync(1)
    });
}

function SpellTemple_CheckBuyAllSpells()
{
    let counts_spell = 0
    let count_spell_player = 0
    let all_spells_player_has_max_level = true
    let game_spells_lib = CustomNetTables.GetTableValue("game_spells_lib", "spell_list")
    let perkInShop = [];
    for (var i = 0; i <= Object.keys(game_spells_lib).length; i++)
    {
        if (game_spells_lib[i] && game_spells_lib[i][5] == active_shop)
        {
            counts_spell = counts_spell + 1
            perkInShop[perkInShop.length + 1] = game_spells_lib[i][1]
        }
    }
    player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
    if (player_table)
    {
        for ( var id in player_table)
        {
            if (player_table[id][1])
            {
                for (var i = 0; i <= perkInShop.length; i++)
                {
                    if(player_table[id][2] < 3 && player_table[id][1] == perkInShop[i])
                    {
                        all_spells_player_has_max_level = false
                    }
                }
            }
        }
    }
    if (all_spells_player_has_max_level)
    {
        return true
    }
    return false 
}

GameEvents.SubscribeProtected("event_spell_shop_drop", SpellTemple_SpellDropNotification);
GameEvents.SubscribeProtected("Shop", SpellTemple_SpellDropNotification);
SpellTemple_InitSpellPanel()
