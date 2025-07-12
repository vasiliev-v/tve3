"use strict";

var activate_cooldown = false
var buy_cooldown = false
var CURRENT_SPELL_SELECTED = null
var players_activated_spells = CustomNetTables.GetTableValue("game_spells_lib", "spell_active")
var CURRENT_SELECT_UNIT = null
var SPELLS_TEXTURE = {}
var player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
var active_shop = null

function InitSpellPanel()
{
    InitSpellList()
}

function GetDotaHud()
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

function InitSpellList()
{
    $("#SpellShopSpellsListBody").RemoveAndDeleteChildren()
    let spell_cost = CustomNetTables.GetTableValue("game_spells_lib", "spell_cost")
    if (spell_cost)
    {
        $("#UnlockPanelBuyButtonCostLabel").text = spell_cost.cost
    }
    let game_spells_lib = CustomNetTables.GetTableValue("game_spells_lib", "spell_list")
    for (var i = 0; i <= Object.keys(game_spells_lib).length; i++)
    {
        if (game_spells_lib[i] && game_spells_lib[i][5] == active_shop)
        {
            CreateSpell(game_spells_lib[i])
        }
    }
}

function CreateSpell(info) 
{
    let SpellShopSpellPanel = $.CreatePanel("Panel", $("#SpellShopSpellsListBody"), "")
    SpellShopSpellPanel.AddClass("SpellShopSpellPanel")
    let SpellShopSpellPanelIcon = $.CreatePanel("Panel", SpellShopSpellPanel, "")
    SpellShopSpellPanelIcon.AddClass("SpellShopSpellPanelIcon")
    SpellShopSpellPanelIcon.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + GetSpellTexture(info[1], GetPlayerSpellLevel(info[1], true)) + '.png")';
    SpellShopSpellPanelIcon.style.backgroundSize = "100%"
    let SpellShopSpellBorder = $.CreatePanel("Panel", SpellShopSpellPanel, "")
    SpellShopSpellBorder.AddClass("SpellShopSpellBorder")

    if (PlayerHasSpell(info[1]))
    {
        SpellShopSpellPanelIcon.SetHasClass("SpellDisabled", false)
    }
    else
    {
        SpellShopSpellPanelIcon.SetHasClass("SpellDisabled", true)
    }

    SetActiveSpellPreview(SpellShopSpellPanel, info)
}

function PlayerHasSpell(spell)
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

function SetActiveSpellPreview(panel, info)
{
    panel.SetPanelEvent("onactivate", function() 
    { 
        Game.EmitSound("General.ButtonClick")
        UpdatePreviewSpell(panel, info)
    });
}

function UpdatePreviewSpell(panel, info)
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
    UpdatePreviewSpellInf(info)
}

function UpdatePreviewSpellInf(info)
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
    SpellShopSpellPanelIcon.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + GetSpellTexture(info[1], GetPlayerSpellLevel(info[1], true)) + '.png")';
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
    SetActivateSpell(SpellPreviewPanelButtonActivate, info)

    let SpellPreviewPanelButtonUpgrade = $.CreatePanel("Panel", SpellPreviewPanelNameButton, "")
    SpellPreviewPanelButtonUpgrade.AddClass("SpellPreviewPanelButtonActivate")
    let SpellPreviewPanelButtonUpgradeLabel = $.CreatePanel("Label", SpellPreviewPanelButtonUpgrade, "")
    SpellPreviewPanelButtonUpgradeLabel.AddClass("SpellPreviewPanelButtonActivateLabel")
    SpellPreviewPanelButtonUpgradeLabel.text = $.Localize("#SpellShop_Upgrade")
    SetUpgradeSpell(SpellPreviewPanelButtonUpgrade, info)

    if (GetPlayerSpellLevel(info[1]) == 0)
    {
        SpellPreviewPanelButtonUpgrade.visible = false
    }
    if (GetPlayerSpellLevel(info[1]) >= 3)
    {
        SpellPreviewPanelButtonUpgrade.visible = false
    }

    if (CheckBuyAllSpells())
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
            if (GetPlayerSpellLevel(info[1]) < i)
            {
                SpellPreviewLevelLabel.text = $.Localize("#SpellShop_SpellPreviewUpgrade") + " " + i + " <font color='red'>(" + $.Localize("#SpellShop_no_buying_spell") + ")</font>"
            }
            let SpellPreviewLevelLabelDesc = $.CreatePanel("Label", $("#PreviewSpellInfo"), "")
            SpellPreviewLevelLabelDesc.AddClass("SpellPreviewLevelLabelDesc")
            SpellPreviewLevelLabelDesc.text = $.Localize("#" + info[4][i])
            if (GetPlayerSpellLevel(info[1]) >= 3)
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

function SetActivateSpell(panel, info)
{
    panel.SetPanelEvent("onactivate", function() 
    { 
        Game.EmitSound("General.ButtonClick")
        ActivateSpell(info)
    });
}

function ActivateSpell(info)
{
    if (CheckBuyAllSpells())
    {
        return
    }
    if (buy_cooldown)
    {
        return
    }
    if (GetPlayerSpellLevel(info[1]) >= 3)
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

function FindDotaHudElement(sId)
{
	return GetDotaHud().FindChildTraverse(sId);
}

function SetUpgradeSpell(panel, info)
{
    panel.SetPanelEvent("onactivate", function()
    {
        Game.EmitSound("General.ButtonClick")
        UpgradeSpell(info)
    });
}

function UpgradeSpell(info)
{
    if (buy_cooldown)
    {
        return
    }
    if (GetPlayerSpellLevel(info[1]) >= 3)
    {
        return
    }
    $.Schedule(0.25, function()
    {
        buy_cooldown = false
    })
    let nextLvl = GetPlayerSpellLevel(info[1]) + 1
    let cost = GetSpellCost(info[1], nextLvl)
    let player_coins = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["0"]["1"]
    if (player_coins && cost && player_coins >= cost)
    {
        buy_cooldown = true
        GameEvents.SendCustomGameEventToServer("event_upgrade_spell", {spell_name: info[1]});
    }
}

function OpenSpellShop()
{
    if(active_shop == 0)
    {
        $("#SpellShopPanel").SetHasClass("CloseSpellShop", true) 
        active_shop = null
    }
    else
    {
        active_shop = 0
        $("#SpellShopPanel").SetHasClass("CloseSpellShop", false) // !$("#SpellShopPanel").BHasClass("CloseSpellShop")
        InitSpellList()
    }
}

function OpenSpellShoTroll()
{
    if(active_shop == 1)
    {
        $("#SpellShopPanel").SetHasClass("CloseSpellShop", true) 
        active_shop = null
    }
    else
    {
        active_shop = 1
        $("#SpellShopPanel").SetHasClass("CloseSpellShop", false) // !$("#SpellShopPanel").BHasClass("CloseSpellShop")
        InitSpellList()
    }
}

function CloseSpellShop()
{
    $("#SpellShopPanel").SetHasClass("CloseSpellShop",true ) // !$("#SpellShopPanel").BHasClass("CloseSpellShop")
    active_shop = null
}

CustomNetTables.SubscribeNetTableListener( "game_spells_lib", UpdateSpellsLibTable );
CustomNetTables.SubscribeNetTableListener( "Shop", UpdateItem);

function UpdateSpellsLibTable(table, key, data ) 
{
	if (table == "game_spells_lib") 
	{
		if (key == "spell_active") 
        {
            UpdateCurrentSpells(data)
		}
	}
}

function UpdateItem(table, key, data ) 
{
	if (table == "Shop") 
	{
        if (key == String(Players.GetLocalPlayer())) 
        {
            player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer())["12"];
            UpdateHasSpells()
		}
	}
}

function IsSpellActivate(spell_name)
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

function GetPlayerSpellLevel(spell_name, texture)
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

function GetSelectedPlayerSpellLevel(spell_name, id)
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

function UpdateCurrentSpells(data)
{
    if (CURRENT_SPELL_SELECTED != null)
    {
        UpdatePreviewSpellInf(CURRENT_SPELL_SELECTED)
    }
    players_activated_spells = data
}

function GetSpellTexture(spell_name, any_level)
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

function GetSpellCost(spell_name, level)
{
    let game_spells_lib = CustomNetTables.GetTableValue("game_spells_lib", "spell_list")
    for (var i = 0; i <= Object.keys(game_spells_lib).length; i++)
    {
        if (game_spells_lib[i] && game_spells_lib[i][1] == spell_name)
        {
            if (game_spells_lib[i][8])
            {
                return game_spells_lib[i][8][level]
            }
        }
    }
    return 0
}

function SetShowText(panel, text, spell, level)
{
    panel.SetPanelEvent('onmouseover', function() {
        $.DispatchEvent('DOTAShowTextTooltip', panel, "<b>" + $.Localize("#"+spell) + " " + level + "</b><br>" + $.Localize("#"+text)) });
        
    panel.SetPanelEvent('onmouseout', function() {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });       
}

function RemoveText(panel, text)
{
    panel.SetPanelEvent('onmouseover', function() 
    {
        
    });
    panel.SetPanelEvent('onmouseout', function() 
    {
        $.DispatchEvent('DOTAHideTextTooltip', panel);
    });       
}

function BuyRandomSpell()
{
    if (CheckBuyAllSpells())
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

function UpdateHasSpells()
{
    $("#PreviewSpellInfo").RemoveAndDeleteChildren()
    InitSpellList()
}

function SpellDropNotification(data)
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
        SpellShopSpellPanelIcon.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + GetSpellTexture(data.spell_name, data.upgrade) + '.png")';
        SpellShopSpellPanelIcon.style.backgroundSize = "100%"
    }
    else
    {
        SpellShopSpellPanelIcon.style.backgroundImage = 'url("file://{images}/custom_game/spell_shop/spell_icons/' + GetSpellTexture(data.spell_name) + '.png")';
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

function CheckBuyAllSpells()
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

GameEvents.SubscribeProtected("event_spell_shop_drop", SpellDropNotification);
GameEvents.SubscribeProtected("Shop", SpellDropNotification);
InitSpellPanel()
