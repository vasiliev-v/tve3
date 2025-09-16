var CURRENT_TAB_INVENTORY = "CouriersPanel"
var CURRENT_TAB_STORE = "PetsDonateItems"
var EVENT_REGISTERED = false
var UPDATE_STORE = false
function ToggleShop() 
{
	player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer());
    $("#DonateShopPanel").SetHasClass("Open", !$("#DonateShopPanel").BHasClass("Open"))
    if (!FIRST_INIT_STORE || UPDATE_STORE)
    {
        FIRST_INIT_STORE = true
        UPDATE_STORE = false
        InitShop()
        SetMainCurrency()
        InitMainPanel()
        InitItems()
        InitInventory()
    }
}

CustomNetTables.SubscribeNetTableListener( "Shop", UpdateShop);
CustomNetTables.SubscribeNetTableListener( "Shop_active", UpdateShop);

function UpdateShop(t, k, d)
{
    if (t == "Shop" && k == Players.GetLocalPlayer())
    {
        if ($("#DonateShopPanel").BHasClass("Open"))
        {
            InitShop()
            SetMainCurrency()
            InitMainPanel()
            InitItems()
            InitInventory()
        }
        else
        {
            UPDATE_STORE = true
        }
        if (GameUI.CustomUIConfig().UpdateBPButton)
        {
            GameUI.CustomUIConfig().UpdateBPButton()
        }
    }
    if (t == "Shop_active" && k == Players.GetLocalPlayer())
    {
        player_active_items = d
        SetMainCurrency()
        InitInventory()
    }
}

CustomNetTables.SubscribeNetTableListener( "Shop", UpdateShop);

function InitShop() 
{
	player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer());

	$("#TrollChance").SetPanelEvent('onmouseover', function() 
    {
	    $.DispatchEvent('DOTAShowTextTooltip', $("#TrollChance"), $.Localize( "#shop_trollchance" ) + player_table[2][0] + "%<br>" + $.Localize( "#shop_trollchance_date") + player_table[2][1]); 
	});
	    
	$("#TrollChance").SetPanelEvent('onmouseout', function() 
    {
	    $.DispatchEvent('DOTAHideTextTooltip', $("#TrollChance"));
	});

	$("#BonusRate").SetPanelEvent('onmouseover', function() 
    {
        $.DispatchEvent('DOTAShowTextTooltip', $("#BonusRate"), $.Localize( "#shop_bonusrate" ) + player_table[3][0] + "%<br>" + $.Localize( "#shop_bonusrate_date") + player_table[3][1]); 
    });
    
	$("#BonusRate").SetPanelEvent('onmouseout', function() 
    {
	    $.DispatchEvent('DOTAHideTextTooltip', $("#BonusRate"));
	});

    $("#BattlePassButton").SetPanelEvent('onmouseover', function() 
    {
        $.DispatchEvent('DOTAShowTextTooltip', $("#BattlePassButton"), $.Localize( "#battlepass_date") + player_table[15][0]); 
    });
    
	$("#BattlePassButton").SetPanelEvent('onmouseout', function() 
    {
	    $.DispatchEvent('DOTAHideTextTooltip', $("#BattlePassButton"));
	});

    if (!EVENT_REGISTERED)
    {
        GameEvents.SubscribeProtected( 'shop_set_currency', SetCurrency ); // Установление валюты переменные gold, gem
        GameEvents.SubscribeProtected( 'shop_error_notification', ShopError ); // Вызов ошибки переменная text - название ошибки
        GameEvents.SubscribeProtected( 'shop_reward_request', RewardRequest ); // Показывает полученный предмет
        // GameEvents.SubscribeProtected( 'ChestAnimationOpen', ChestAnimationOpen ); // Запускает анимацию
        EVENT_REGISTERED = true
    }
}

function SetMainCurrency() 
{
	if (player_table[0]) 
    {
		$("#Currency").text = String(player_table[0][0])
		$("#Currency2").text = 	String(player_table[0][1])	
	}
}

function SetCurrency(data) 
{
	$("#Currency").text = String(data.gold || 0)
	$("#Currency2").text = 	String(data.gem || 0)
}

function ShopError(data) 
{
	$( "#shop_error_panel" ).style.visibility = "visible";
	if (data) 
    {
		$( "#shop_error_label" ).text = $.Localize("#" +  data );
	}
	$( "#shop_error_label" ).SetHasClass( "error_visible", false );
	$.Schedule( 2, RemoveError );
}

function SwitchTab(tab, button) 
{
	$("#MainContainer").style.visibility = "collapse";
	$("#ItemsContainer").style.visibility = "collapse";
	$("#InventoryContainer").style.visibility = "collapse";
	$("#GemContainer").style.visibility = "collapse";
    for (child of $("#DonateShopTopButtons").Children())
    {
        child.SetHasClass("IsActiveButton", false)
    }
    $("#" + button).SetHasClass("IsActiveButton", true)
	$("#" + tab).style.visibility = "visible";
}

function InitMainPanel() 
{
	$('#PopularityRecomDonateItems').RemoveAndDeleteChildren()
	for (var i = 0; i <= Object.keys(Items_recomended).length; i++) 
    {
        if (Items_recomended[i])
        {
            CreateItem($('#PopularityRecomDonateItems'), Items_recomended, i)
        }
	}
	$("#ChestItemText").text = $.Localize("#" +  Items_ADS[0][0] )
	$("#AdsItemText").text = $.Localize("#" +  Items_ADS[1][0] )
	$("#AdsChests").style.backgroundImage = 'url("file://{images}/custom_game/shop/ads/' + Items_ADS[0][1] + '.png")';
	$("#AdsChests").style.backgroundSize = "100%"
	$("#AdsItem_1").style.backgroundImage = 'url("file://{images}/custom_game/shop/ads/' + Items_ADS[1][1] + '.png")';
	$("#AdsItem_1").style.backgroundSize = "100%"
} 

function ItemTooltipShow(panel, item_name)
{
    panel.SetPanelEvent("onmouseover", () => 
    {
        $.DispatchEvent(
            "UIShowCustomLayoutParametersTooltip",
            panel,
            "shop_tooltip",
            "file://{resources}/layout/custom_game/donate_shop/shop_tooltip.xml",
            "item_name=" + item_name
        );
    });
    panel.SetPanelEvent("onmouseout", () => 
    {
        $.DispatchEvent("UIHideCustomLayoutTooltip", panel, "shop_tooltip");
    });
}

function CreateItem(panel, table, i, is_inventory) 
{
    let is_chest = IsItemChest(table[i][1])
    
    if (!is_inventory)
    {
        if(table[i][3] == "999999999")
        {
            return
        }
    }
    if (is_inventory)
    {
        if (is_chest)
        {
            if (!PlayerHasChest(table[i][1]))
            {
                return
            }
        }
        else
        {
            if (!PlayerHasItem(table[i][1]))
            {
                return
            }
        }
    }

	let Recom_item = $.CreatePanel("Panel", panel, "");
	Recom_item.AddClass("RecomItem");

    ItemTooltipShow(Recom_item, table[i][5])

    let ItemImage = $.CreatePanel("Panel", Recom_item, "");
    ItemImage.AddClass("ItemImage");

    const itemName = table[i][5];
    const isLabelItem = typeof itemName === "string" && itemName.indexOf("label_") === 0;

    if (isLabelItem)
    {
        ItemImage.AddClass("LabelItemImage");
        let labelItemText = $.CreatePanel("Label", ItemImage, "");
        labelItemText.AddClass("LabelItemText");
        labelItemText.text = $.Localize("#" + itemName);
    }
    else
    {
        ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + table[i][4] + '.png")';
        ItemImage.style.backgroundSize = "100%";
    }

        let BuyItemPanel = $.CreatePanel("Panel", Recom_item, "BuyItemPanel");
        BuyItemPanel.AddClass("BuyItemPanel");

    if (is_inventory && is_chest)
    {
        let chest_count_label = $.CreatePanel("Label", Recom_item, "");
        chest_count_label.AddClass("chest_count_label");
        chest_count_label.text = PlayerGetChestCounter(table[i][1])
    }

    let box_color = null

    if (BOX_SHADOW_COLORS[table[i][7]])
    {
        box_color = BOX_SHADOW_COLORS[table[i][7]]
    }

    if (table[i][4] == "sounds")
    {
        ItemImage.style.backgroundSize = "100%"
        Recom_item.AddClass("SoundItem")
    }

	let ItemPrice = $.CreatePanel("Panel", BuyItemPanel, "ItemPrice");
	ItemPrice.AddClass("ItemPrice");
    
    if (!is_inventory)
    {
        if (table[i][3] == "9999999")
        {
            //BuyItemPanel.style.backgroundColor = "Indigo"
            let PriceLabel = $.CreatePanel("Label", ItemPrice, "PriceLabel");
            PriceLabel.AddClass("PriceLabel");
            PriceLabel.text = $.Localize( "#shop_gold" )
        }
        else if (table[i][3] == "99999999")
        {
            //BuyItemPanel.style.backgroundColor = "SlateBlue"
            let PriceLabel = $.CreatePanel("Label", ItemPrice, "PriceLabel");
            PriceLabel.AddClass("PriceLabel");
            PriceLabel.text = $.Localize( "#shop_event" )
        }
        else if (PlayerHasItem(table[i][1]) && !is_chest)
        {
            Recom_item.AddClass("IsItemBought")
            let PriceLabel = $.CreatePanel("Label", ItemPrice, "PriceLabel");
            PriceLabel.AddClass("PriceLabel");
            PriceLabel.text = $.Localize( "#shop_bought" )
        }
        else
        {
            let PriceIcon = $.CreatePanel("Panel", ItemPrice, "PriceIcon");
            PriceIcon.AddClass("PriceIcon" + table[i][2]);
            let PriceLabel = $.CreatePanel("Label", ItemPrice, "PriceLabel");
            PriceLabel.AddClass("PriceLabel");
            PriceLabel.text = table[i][3]
            SetItemBuyFunction(Recom_item, table[i])
        }
    }
    else
    {
        Recom_item.AddClass("IsItemInventory")
        if (table[i][5].indexOf("chest") == 0 ) 
        {
            SetOpenChestPanel(Recom_item, table[i])
            let PriceLabel = $.CreatePanel("Label", ItemPrice, "PriceLabel");
            PriceLabel.AddClass("PriceLabel");
            PriceLabel.text = $.Localize( "#shop_open" )
        }
        else
        {
            let check_item_id = table[i][1]
            if (table[i][5].indexOf("particle") == 0 ) 
            {
                check_item_id = check_item_id - 100
            }
            let is_item_activated = IsItemActivated(check_item_id)
            let PriceLabel = $.CreatePanel("Label", ItemPrice, "PriceLabel");
            PriceLabel.AddClass("PriceLabel");
            if (is_item_activated)
            {
                PriceLabel.text = $.Localize( "#SpellShop_Deactivate" )
                Recom_item.AddClass("DeactivateItem")
            }
            else
            {
                PriceLabel.text = $.Localize( "#SpellShop_Activate" )
            }
            SetItemInventory(Recom_item, table[i], is_item_activated)
        }
    }
}

function PlayerHasItem(id)
{
    for ( var item in player_table[1] )
    {
       	if (item == id) 
        {
       		return true
       	}
    }
    return false
}

function PlayerHasChest(id)
{
    for ( var chest in player_table[4] )
    {
        if (player_table[4][chest][1] == id) 
        {
            return true
        }
    }
    return false
}

function PlayerGetChestCounter(id)
{
    for ( var chest in player_table[4] )
    {
        if (player_table[4][chest][1] == id) 
        {
            return player_table[4][chest][2]
        }
    }
    return 0
}

function IsItemChest(id)
{
    if (data_chest && data_chest[id])
    {
        return true
    }
    return false
}

function IsItemActivated(id)
{
    for (slot in player_active_items)
    {
        let item_id = player_active_items[slot]
        if (item_id == id)
        {
            return true
        }
    }
    return false
}

function InitItems() 
{
	$('#AllDonateItems').RemoveAndDeleteChildren()
    ReCreateItemsStoreList(CURRENT_TAB_STORE)
}

function SwitchShopTab(tab, button) 
{
    for (child of $("#MenuItems").Children())
    {
        child.SetHasClass("IsActiveButton", false)
    }
    ReCreateItemsStoreList(tab)
	$("#" + button).SetHasClass("IsActiveButton", true)
}

function SwitchInventoryShopTab(tab, button) 
{
    for (child of $("#MenuInventory").Children())
    {
        child.SetHasClass("IsActiveButton", false)
    }
    ReCreateItemsInventoryList(tab)
	$("#" + button).SetHasClass("IsActiveButton", true)
}

function ReCreateItemsStoreList(tab)
{
    $("#AllDonateItems").RemoveAndDeleteChildren()
    CURRENT_TAB_STORE = tab
    let items_list_table = {}
    if (tab == "AllDonateItems")
    {
        items_list_table = Items_ALL
    }
    if (tab == "PetsDonateItems")
    {
        items_list_table = Items_pets
    }
    if (tab == "EffectsDonateItems")
    {
        items_list_table = Items_effects
    }
 //    if (tab == "GemDonateItems")
 //    {
 //        items_list_table = Items_gem
  //   }
    if (tab == "SubscribeDonateItems")
    {
        items_list_table = Items_subscribe
    }
    if (tab == "ChestDonateItems")
    {
        items_list_table = chests_table
    }
    if (tab == "SkinDonateItems")
    {
        items_list_table = Items_skin
    }
    if (tab == "LabelDonateItems")
    {
        items_list_table = Items_label
    }
    if (tab == "TowerDonateItems")
    {
        items_list_table = Items_tower
    }
    if (tab == "WispDonateItems")
    {
        items_list_table = Items_wisp
    }
    if (tab == "SoundsDonateItems")
    {
        items_list_table = Items_sounds
    }
 //   if (tab == "SpraysonateItems")
 //    {
//         items_list_table = Items_sprays
 //    }
    for (let i = 0; i <= Object.keys(items_list_table).length; i++) 
    {
        if (items_list_table[i])
        {
            CreateItem($('#AllDonateItems'), items_list_table, i)
        }
    }
}

function BuyCurrencyPanelActive()
{
    $("#info_item_buy").SetHasClass("IsChest", false)
    $("#ItemIconLarge").visible = false
	$("#info_item_buy").style.visibility = "visible"
	$("#ItemNameInfo").text = $.Localize( "#buy_currency" )

	let Panel_for_desc = $.CreatePanel("Label", $("#ItemInfoBody"), "Panel_for_desc");
	Panel_for_desc.AddClass("Panel_for_desc");

	let Item_desc = $.CreatePanel("Label", Panel_for_desc, "Item_desc");
	Item_desc.AddClass("Item_desc");
	Item_desc.text = $.Localize( "#buy_currency_description" )

	let columns = $.CreatePanel("Panel", $("#ItemInfoBody"), "columns");
	columns.AddClass("columns_donate");

	let column_1 = $.CreatePanel("Panel", columns, "column_1");
	column_1.AddClass("column_donate");

	let column_2 = $.CreatePanel("Panel", columns, "column_2");
	column_2.AddClass("column_donate");

	$.CreatePanel("Label", column_1, "Discord", { onactivate: `ExternalBrowserGoToURL(${button_donate_link_4});`, text: "TvE Shop", class:"link_button" });
    $.CreatePanel("Label", column_2, "Paypal", { onactivate: `ExternalBrowserGoToURL(${button_donate_link_2});`, text: "PayPal", class:"link_button" });
	//$.CreatePanel("Label", column_1, "PatreonButton", { onactivate: `ExternalBrowserGoToURL(${button_donate_link_1});`, text: "Patreon", class:"link_button" });
    //$.CreatePanel("Label", column_2, "DonateStream", { onactivate: `ExternalBrowserGoToURL(${button_donate_link_3});`, text: "DonStream", class:"link_button" });
}

function CloseItemInfo()
{
    $("#info_item_buy").style.visibility = "collapse"
    $("#ItemInfoBody").RemoveAndDeleteChildren()
}

function InitInventory() 
{
	$('#PlayerItemsContainer').RemoveAndDeleteChildren()
    ReCreateItemsInventoryList(CURRENT_TAB_INVENTORY)
    UpdateChestCounter()
}

function UpdateChestCounter()
{
    let ChestCounterPanel = $("#ChestCounterPanel")
    let ChestCounter = $("#ChestCounter")
    let chest_counter = 0
    for (var i = 0; i <= Object.keys(chests_table).length; i++) 
    {
        if (chests_table[i] && player_table[4][chests_table[i][1]])
        {
            chest_counter = chest_counter + Number(player_table[4][chests_table[i][1]][2])
        }
    }
    if (chest_counter > 0)
    {
        ChestCounterPanel.style.opacity = "1"
        ChestCounter.text = chest_counter
    }
    else
    {
        ChestCounterPanel.style.opacity = "0"
        ChestCounter.text = chest_counter
    }
}

function ReCreateItemsInventoryList(tab)
{
    $("#PlayerItemsContainer").RemoveAndDeleteChildren()
    CURRENT_TAB_INVENTORY = tab
    let items_list_table = {}
    if (tab == "CouriersPanel")
    {
        items_list_table = Items_pets
    }
    if (tab == "EffectsPanel")
    {
        items_list_table = Items_effects
    }
    if (tab == "ChestsPanel")
    {
        items_list_table = chests_table
    }
    if (tab == "SkinPanel")
    {
        items_list_table = Items_skin
    }
    if (tab == "LabelPanel")
    {
        items_list_table = Items_label
    }
    if (tab == "TowerPanel")
    {
        items_list_table = Items_tower
    }
    if (tab == "WispPanel")
    {
        items_list_table = Items_wisp
    }
    for (var i = 0; i <= Object.keys(items_list_table).length; i++) 
    {
        if (items_list_table[i])
        {
            CreateItem($('#PlayerItemsContainer'), items_list_table, i, true)
        }
    }
}

function SetItemBuyFunction(panel, table)
{
    panel.SetPanelEvent("onactivate", function()
    {
        $("#info_item_buy").SetHasClass("IsChest", false)
    	$("#info_item_buy").style.visibility = "visible"
    	$("#ItemNameInfo").text = $.Localize("#" +  table[4] )
        $("#ItemIconLarge").visible = true
        $("#ItemIconLarge").style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + table[4] + '.png")'
        $("#ItemIconLarge").style.backgroundSize = "100%"
		$("#ItemInfoBody").style.flowChildren = "down"

		let Panel_for_desc = $.CreatePanel("Label", $("#ItemInfoBody"), "Panel_for_desc");
		Panel_for_desc.AddClass("Panel_for_desc");

		let Item_desc = $.CreatePanel("Label", Panel_for_desc, "Item_desc");
		Item_desc.AddClass("Item_desc");

		let str = table[4].replace(/[^a-zа-яё]/gi, '');
		Item_desc.text = $.Localize("#" + str + "_description" )

		if (table[4].indexOf("chest") == 0) 
        {
            $("#info_item_buy").SetHasClass("IsChest", true)
            let chest_table = GetChestInfo(Number(table[1]))
			let ChestItemPreview = $.CreatePanel("Panel", $("#ItemInfoBody"), "ChestItemPreview");
			ChestItemPreview.AddClass("ChestItemPreview");
			for (var i = 0; i <= Object.keys(Items_ALL).length; i++) 
            {
                if (Items_ALL[i])
                {
                    CreateItemInChestPreview(ChestItemPreview, Items_ALL, i, chest_table)
                }
		    }
		    CreateItemCurrencyPreview(ChestItemPreview, chest_table[2][1], chest_table[2][3], chest_table[2][2])
		}

		let BuyItemPanel = $.CreatePanel("Panel", $("#ItemInfoBody"), "BuyItemPanel");
		BuyItemPanel.AddClass("BuyItemPanelInfo");

		let PriceLabel = $.CreatePanel("Label", BuyItemPanel, "PriceLabel");
		PriceLabel.AddClass("PriceLabelInfo");
		PriceLabel.text = $.Localize( "#shop_buy" )

		BuyItemPanel.SetPanelEvent("onactivate", function() 
        { 
            BuyItemFunction(table); 
            CloseItemInfo(); 
        });
    });  
}

function BuyItemFunction(table) 
{
	if ((table[2] == "gold" && Number(table[3]) <= Number(player_table[0][0])) || (table[2] == "gem" && Number(table[2]) <= Number(player_table[0][1])) && Number(table[3]) != "999999") 
	{
		GameEvents.SendCustomGameEventToServer( "BuyShopItem", { id: Players.GetLocalPlayer(), TypeDonate: table[2] , Coint: table[3], Nick: table[5], Num: table[1]  } );
	} 
	else  
	{
		ShopError("shop_no_money")
    }
}

function GetChestInfo(id)
{
    for (chest_id in data_chest)
    {
        if (chest_id == id)
        {
            return data_chest[chest_id]
        }
    }
    return null
}

function CreateItemCurrencyPreview(panel, currency, count, chance) 
{
	let Chest_in_item = $.CreatePanel("Panel", panel, "item_" + currency);
	Chest_in_item.AddClass("Chest_in_item_preview");

	//CreateItemChance(Chest_in_item, $.Localize("#" + "shop_chance") + " " + chance + "%<br>" + $.Localize("#" + "shop_currency_count") + " " + $.Localize("#" + "shop_currency_count_from") + " " + count[1] + " " + $.Localize("#shop_currency_count_to") + " " + count[2])

	let ItemImage = $.CreatePanel("Panel", Chest_in_item, "");
	ItemImage.AddClass("ItemChestImage_preview");
	ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + currency + '.png")';
	ItemImage.style.backgroundSize = "100%"

	let RarePanel = $.CreatePanel("Panel", Chest_in_item, "");
	RarePanel.AddClass("RarePanel");
	ItemImage.style.borderBrush = 'gradient( linear, 0% 0%, 0% 100%, from( #b28a33 ), to( #664c15 ))';

	let ItemName = $.CreatePanel("Label", RarePanel, "ItemName");
	ItemName.AddClass("ItemChestName_preview");
	ItemName.text = $.Localize( "#shop_currency_" + currency)
}

function CreateItemInChestPreview(panel, table, i, table_chest) 
{
	for (let item_chest_num in table_chest[1] ) 
    {
        let item_chest_info = table_chest[1][item_chest_num]
		if (table[i][1] == item_chest_info[1]) 
        {
			if (!panel.FindChildTraverse("item_" + item_chest_info[1])) 
            {
				let Chest_in_item = $.CreatePanel("Panel", panel, "item_" + item_chest_info[1]);
				Chest_in_item.AddClass("Chest_in_item_preview");

				//CreateItemChance(Chest_in_item, $.Localize("#" + "shop_chance") + " " + item_chest_info[2] + "%")

				let ItemImage = $.CreatePanel("Panel", Chest_in_item, "");
				ItemImage.AddClass("ItemChestImage_preview");
				ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + table[i][4] + '.png")';
				ItemImage.style.backgroundSize = "100%"

				let RarePanel = $.CreatePanel("Panel", Chest_in_item, "");
				RarePanel.AddClass("RarePanel");

                let color_rare = CHEST_GRADIENT_COLORS[table[i][7]]
                if (color_rare)
                {
                    ItemImage.style.borderBrush = 'gradient( linear, 0% 0%, 0% 100%, from( ' + CHEST_GRADIENT_COLORS[table[i][7]][0] + ' ), to( '+ CHEST_GRADIENT_COLORS[table[i][7]][1] + ' ))';
                }

				let ItemName = $.CreatePanel("Label", RarePanel, "ItemName");
				ItemName.AddClass("ItemChestName_preview");
				ItemName.text = $.Localize("#" +  table[i][5] )
			
                if (PlayerHasItem(item_chest_info[1]))
                {
                    Chest_in_item.AddClass("HasItemInChest")
                }
			}
		}
	}
}

function RemoveError() 
{
	$( "#shop_error_panel" ).style.visibility = "collapse";
	$( "#shop_error_label" ).SetHasClass( "error_visible", true );
	$( "#shop_error_label" ).text = "";
}

function ShopBuy(data) 
{
	$( "#shop_buy_panel" ).style.visibility = "visible";
	if (data) 
    {
		$( "#shop_buy_label" ).text = $.Localize("#" +  data );
	}
	$( "#shop_buy_label" ).SetHasClass( "buy_visible", false );
	$.Schedule( 2, RemoveBuy );
}

function RemoveBuy() 
{
	$( "#shop_buy_panel" ).style.visibility = "collapse";
	$( "#shop_buy_label" ).SetHasClass( "buy_visible", true );
	$( "#shop_buy_label" ).text = "";
}

function SetItemInventory(panel, table, is_item_activated)
{
	if (table[5].indexOf("pet") == 0) 
    {
		panel.SetPanelEvent("onactivate", function() 
        { 
	 		SelectCourier(table[1], is_item_activated)
	    });
	} 
	else if (table[5].indexOf("particle") == 0) 
    {
		panel.SetPanelEvent("onactivate", function() 
        { 
	 		SelectParticle(table[1], is_item_activated)
	    });
	}
	else if (table[5].indexOf("skin") == 0 && table[5].indexOf("skin_wisp") != 0) 
    {
		panel.SetPanelEvent("onactivate", function() 
        { 
	 		SelectSkin(table[1], is_item_activated)
	    });
	}
	else if (table[5].indexOf("skin_wisp") == 0 ) 
    {
		panel.SetPanelEvent("onactivate", function() 
        { 
	 		SelectWisp(table[1], is_item_activated)
	    });
	}
	else if (table[5].indexOf("tower") == 0 || table[5].indexOf("true_sight_tower") == 0 || table[5].indexOf("high_true_sight_tower") == 0 || table[5].indexOf("flag") == 0) {
		panel.SetPanelEvent("onactivate", function() 
        { 
	 		SelectTower(table, is_item_activated)
	    });
	}
    else if (table[5].indexOf("label") == 0) 
    {
		panel.SetPanelEvent("onactivate", function() 
        { 
	 		SelectLabel(table[1], is_item_activated)
	    });
	}
}

function CreateItemChance(panel, label) 
{
	panel.SetPanelEvent('onmouseover', function() 
    {
	    $.DispatchEvent('DOTAShowTextTooltip', panel, label); 
	});
	panel.SetPanelEvent('onmouseout', function() 
    {
	    $.DispatchEvent('DOTAHideTextTooltip', panel);
	});
}

function SelectCourier(num, is_item_activated)
{
    if (is_item_activated)
    {
        GameEvents.SendCustomGameEventToServer( "SelectPets", { id: Players.GetLocalPlayer(),part:num, offp:true, name:num } );
		GameEvents.SendCustomGameEventToServer( "SetDefaultPets", { id: Players.GetLocalPlayer(),part:"0"} );
        return
    }
    GameEvents.SendCustomGameEventToServer( "SelectPets", { id: Players.GetLocalPlayer(), part:num, offp:false, name:num } );
    GameEvents.SendCustomGameEventToServer( "SetDefaultPets", { id: Players.GetLocalPlayer(), part:String(num)} );
}

function SelectParticle(num, is_item_activated)
{
    if (is_item_activated)
    {
        GameEvents.SendCustomGameEventToServer( "SelectPart", { id: Players.GetLocalPlayer(),part:String(num) , offp:true, name:String(num)  } );
		GameEvents.SendCustomGameEventToServer( "SetDefaultPart", { id: Players.GetLocalPlayer(),part:"0"} );
        return
    }
    let numPart = Number(num)-100
    GameEvents.SendCustomGameEventToServer( "SelectPart", { id: Players.GetLocalPlayer(), part:String(numPart), offp:false, name:String(numPart) } );
    GameEvents.SendCustomGameEventToServer( "SetDefaultPart", { id: Players.GetLocalPlayer(), part:String(numPart)} );	
}

function SelectSkin(num, is_item_activated)
{
    $.Msg("1")
    if (is_item_activated)
    {
        $.Msg("2")
        GameEvents.SendCustomGameEventToServer( "SelectSkin", { id: Players.GetLocalPlayer(),part:String(num) , offp:true, name:String(num)  } );
		GameEvents.SendCustomGameEventToServer( "SetDefaultSkin", { id: Players.GetLocalPlayer(),part:"0"} );
        return
    }
    $.Msg("3")
    GameEvents.SendCustomGameEventToServer( "SelectSkin", { id: Players.GetLocalPlayer(), part:String(num), offp:false, name:String(num) } );
    GameEvents.SendCustomGameEventToServer( "SetDefaultSkin", { id: Players.GetLocalPlayer(), part:String(num)} );	
}

function SelectLabel(num, is_item_activated)
{
    if (is_item_activated)
    {
        GameEvents.SendCustomGameEventToServer( "SelectLabel", { id: Players.GetLocalPlayer(),part:String(num) , offp:true, name:String(num)  } );
		GameEvents.SendCustomGameEventToServer( "SetDefaultLabel", { id: Players.GetLocalPlayer(),part:"0"} );
        return
    }
    GameEvents.SendCustomGameEventToServer( "SelectLabel", { id: Players.GetLocalPlayer(), part:String(num), offp:false, name:String(num) } );
    GameEvents.SendCustomGameEventToServer( "SetDefaultLabel", { id: Players.GetLocalPlayer(), part:String(num)} );	
}

function SelectTower(table, is_item_activated)
{
    var num = table[1];
	var type = table[5];
    if (is_item_activated)
    {
        GameEvents.SendCustomGameEventToServer( "SelectSkinTower", { id: Players.GetLocalPlayer(),part:String(num) , offp:true, name:String(num),type: type   } );
		GameEvents.SendCustomGameEventToServer( "SetDefaultSkinTower", { id: Players.GetLocalPlayer(),part:"0",type: type } );
        return
    }
    GameEvents.SendCustomGameEventToServer( "SelectSkinTower", { id: Players.GetLocalPlayer(), part:String(num), offp:false, name:String(num), type: type } );
    GameEvents.SendCustomGameEventToServer( "SetDefaultSkinTower", { id: Players.GetLocalPlayer(), part:String(num), type: type } );	
}

function SelectWisp(num, is_item_activated)
{
    if (is_item_activated)
    {
        GameEvents.SendCustomGameEventToServer( "SelectSkinWisp", { id: Players.GetLocalPlayer(),part:String(num) , offp:true, name:String(num)  } );
		GameEvents.SendCustomGameEventToServer( "SetDefaultSkinWisp", { id: Players.GetLocalPlayer(),part:"0"} );
        return
    }
	GameEvents.SendCustomGameEventToServer( "SelectSkinWisp", { id: Players.GetLocalPlayer(), part:String(num), offp:false, name:String(num) } );
    GameEvents.SendCustomGameEventToServer( "SetDefaultSkinWisp", { id: Players.GetLocalPlayer(), part:String(num)} );	
}

var SOUND_TICK_WIDTH = 128
var DROP_POS = [0,0]
var STARTING_SPEED = 3600

function SetOpenChestPanel(panel, table)
{
    panel.SetPanelEvent("onactivate", function() 
    {
    	$("#ChestOpenPanelMainClosed").style.visibility = "visible"

        let chest_information = $.CreatePanel("Panel", $("#ChestBodyInfo"), "");
		chest_information.AddClass("chest_information");

		let ChestImage = $.CreatePanel("Panel", chest_information, "");
		ChestImage.AddClass("ChestImageInfo");
		ChestImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + table[5] + '.png")';
		ChestImage.style.backgroundSize = "100%"

        let ChestName = $.CreatePanel("Label", chest_information, "");
		ChestName.AddClass("ChestNameInfoLabel");
        ChestName.text = $.Localize("#" +  table[4] )

        let chest_dropped_panel = $.CreatePanel("Panel",  $("#ChestBodyInfo"), "");
		chest_dropped_panel.AddClass("chest_dropped_panel");

        let chest_dropped_panel_line = $.CreatePanel("Panel", chest_dropped_panel, "chest_dropped_panel_line");
		chest_dropped_panel_line.AddClass("chest_dropped_panel_line");

        let chest_dropped_panel_arrow = $.CreatePanel("Panel", chest_dropped_panel, "");
		chest_dropped_panel_arrow.AddClass("chest_dropped_panel_arrow");

		let ChestAllRewardsPanel = $.CreatePanel("Panel",  $("#ChestBodyInfo"), "ChestAllRewardsPanel");
		ChestAllRewardsPanel.AddClass("ChestAllRewardsPanel");

		let OpenChestButton = $.CreatePanel("Panel",  $("#ChestBodyInfo"), "OpenChestButton");
		OpenChestButton.AddClass("OpenChestButton");

		let OpenChest_Label = $.CreatePanel("Label", OpenChestButton, "");
		OpenChest_Label.text = $.Localize( "#shop_open" )

        let chest_table = GetChestInfo(Number(table[1]))

        for (var i = 0; i <= Object.keys(Items_ALL).length; i++) 
        {
            if (Items_ALL[i])
            {
                CreateItemInChestPreview(ChestAllRewardsPanel, Items_ALL, i, chest_table)
            }
        }

	    // Последним добавляется валюта золота "gem", gold
	    CreateItemCurrencyPreview(ChestAllRewardsPanel, chest_table[2][1], chest_table[2][3], chest_table[2][2])
        RecreateRandomItemsList(chest_dropped_panel_line, chest_table)
		OpenChestButton.SetPanelEvent("onactivate", function() { OpenChest(table);} );
    });  
}

function CloseOpenChest()
{
  	$("#ChestOpenPanelMainClosed").style.visibility = "collapse"
  	$("#ChestBodyInfo").RemoveAndDeleteChildren()
}

function RecreateRandomItemsList(chest_dropped_panel, chest_table)
{
    let items_chest = chest_table[1]

    for (let i = 0; i <= 50; i++)
    {
        let randomIndex = Math.floor(Math.random() * Object.keys(items_chest).length) + 1;
        let randomElement = items_chest[randomIndex];
        CreateItemInRoll(chest_dropped_panel, randomElement, 0, true, 45 == i, i)
    }
}

function CreateItemInRoll(main_panel, item_info, delay_count, roll, drop_slot, c)
{
    $.Schedule( 0.01 * delay_count, function()
    {
        let panel_id = ""
        if (drop_slot)
        {
            panel_id = "dropped_item"
        }

        let chest_roll_item = $.CreatePanel("Panel", main_panel, panel_id);
        chest_roll_item.AddClass("chest_roll_item");

        let chest_roll_img = $.CreatePanel("Panel", chest_roll_item, "");
        chest_roll_img.AddClass("chest_roll_img");

        let ItemImage = $.CreatePanel("Panel", chest_roll_img, "ItemImage");
        ItemImage.AddClass("chest_roll_item_Image");

        let ItemRollRarity = $.CreatePanel("Panel", chest_roll_item, "");
        ItemRollRarity.AddClass("ItemRollRarity");

        let item_info_real = GetItemInfo(item_info[1])
        if (item_info_real != null)
        {
            if (BOX_SHADOW_COLORS[item_info_real[7]])
            {
                ItemRollRarity.style.washColor = BOX_SHADOW_COLORS[item_info_real[7]]
                ItemRollRarity.style.opacity = "0.3"
            }
            ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + item_info_real[4] + '.png")';
            ItemImage.style.backgroundSize = "100%"
        }

        $.Schedule( 0.1, function()
        {
            if (drop_slot)
            {
                let check_pos = chest_roll_item.style.position
                let SpaceFind = check_pos.indexOf('px');
                let center_panel = Number(check_pos.substring(0, SpaceFind))
                SOUND_TICK_WIDTH = (chest_roll_item.actuallayoutwidth / chest_roll_item.actualuiscale_x) + (20 * 2) 
                DROP_POS[0] = -((center_panel - ( (chest_roll_item.actuallayoutwidth / chest_roll_item.actualuiscale_x) * 2) + ((chest_roll_item.actuallayoutwidth / chest_roll_item.actualuiscale_x) * 0.25)) - ((chest_roll_item.actuallayoutwidth / chest_roll_item.actualuiscale_x) / 2))
                DROP_POS[1] = -((center_panel - ( (chest_roll_item.actuallayoutwidth / chest_roll_item.actualuiscale_x) * 2) + ((chest_roll_item.actuallayoutwidth / chest_roll_item.actualuiscale_x) * 0.25)) - ((chest_roll_item.actuallayoutwidth / chest_roll_item.actualuiscale_x) / 2))
            }
        })
    })
}

function CheckDropPos(pos)
{
    let chest_dropped_panel_line = $("#ChestBodyInfo").FindChildTraverse("chest_dropped_panel_line")
    chest_dropped_panel_line.style.position = pos + "px 0px 0px"
}

function GetItemInfo(ID)
{
    for (var i = 0; i <= Object.keys(Items_ALL).length; i++) 
    {
        if (Items_ALL[i])
        {
            if (Items_ALL[i][1] == ID) 
            {
                return Items_ALL[i]
            }
        }
    }
    return null
}

function OpenChest(table) 
{
    let OpenChestButton = $("#ChestBodyInfo").FindChildTraverse("OpenChestButton")
    if (OpenChestButton)
    {
        OpenChestButton.style.opacity = "0"
    }
	GameEvents.SendCustomGameEventToServer( "OpenChestAnimation", {chest_id : table[1], PlayerID2: Players.GetLocalPlayer()});
}

function RewardRequest(data) 
{
    let reward = data.reward
    let current = 0
    let randomly_max_distance = Math.floor(DROP_POS[0]);
    let chest_dropped_panel_line = $("#ChestBodyInfo").FindChildTraverse("chest_dropped_panel_line")
    if (chest_dropped_panel_line)
    {
        let ItemImage = chest_dropped_panel_line.FindChildTraverse("dropped_item").FindChildTraverse("ItemImage")
        let item_info_real = GetItemInfo(reward)
        if (item_info_real != null)
        {
            if (BOX_SHADOW_COLORS[item_info_real[7]])
            {
                ItemRollRarity.style.washColor = BOX_SHADOW_COLORS[item_info_real[7]]
                ItemRollRarity.style.opacity = "0.3"
            }
            ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + item_info_real[4] + '.png")';
            ItemImage.style.backgroundSize = "100%"
        }
        if (reward == "gold") 
        {
            ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/gold.png")';
            ItemImage.style.backgroundSize = "100%"
        }
        if (reward == "gem") 
        {
            ItemImage.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/gem.png")';
            ItemImage.style.backgroundSize = "100%"
        }
    }
    ChestAnimate(current, randomly_max_distance, STARTING_SPEED, SOUND_TICK_WIDTH, reward)
}

function ChestAnimate(current, drop_distance, speed, sound_tick, drop_id)
{
    let chest_dropped_panel_line = $("#ChestBodyInfo").FindChildTraverse("chest_dropped_panel_line")
    if ($("#ChestOpenPanelMainClosed").visible == false)
    {
        return
    }
    if (current <= drop_distance)
    {
        $.Schedule(0.1, function() 
        {
            SetRewardView(drop_id)
        })
        current = drop_distance
        chest_dropped_panel_line.style.position = drop_distance + "px 0px 0px"
        return
    }
    current = current - (speed * Game.GetGameFrameTime())
    sound_tick = sound_tick - (speed * Game.GetGameFrameTime())
    if (sound_tick <= 0)
    {
        sound_tick = SOUND_TICK_WIDTH
        Game.EmitSound("random_wheel_lever")
    }
    if (current <= 0.6 * drop_distance)
    {
        speed = speed - (speed * Game.GetGameFrameTime())
    }
    speed = Math.max(30, speed);
    chest_dropped_panel_line.style.position = current + "px 0px 0px"
    $.Schedule(Game.GetGameFrameTime(), function() 
    {
		ChestAnimate(current, drop_distance, speed, sound_tick, drop_id)
	})
}

function SetRewardView(drop_id)
{
    $("#chest_opened_animation").RemoveAndDeleteChildren()
	let RewardIcon = $.CreatePanel("Panel",  $("#chest_opened_animation"), "RewardIcon");
	RewardIcon.AddClass("ChestOpenImageItem");
	let icon
	if (drop_id) 
    {
        let item_info_real = GetItemInfo(drop_id)
        if (item_info_real != null)
        {
            icon = item_info_real[4]
        }
	    if (drop_id == "gold") 
        {
	    	icon = "gold"
	    }
	    if (drop_id == "gem") 
        {
	    	icon = "gem"
	    }
	}

	RewardIcon.style.backgroundImage = 'url("file://{images}/custom_game/shop/itemicon/' + icon + '.png")';
	RewardIcon.style.backgroundSize = "100%"

	let AcceptButton = $.CreatePanel("Panel",  $("#chest_opened_animation"), "AcceptButton");
	AcceptButton.AddClass("AcceptButton");
	AcceptButton.SetPanelEvent("onactivate", function() { CloseChest(); CloseOpenChest() } );
	
	let LabelAccept = $.CreatePanel("Label", AcceptButton, "LabelAccept");
	LabelAccept.AddClass("LabelAccept");
	LabelAccept.text = $.Localize( "#shop_accept" )
    
    $("#chest_opened_animation").style.visibility = "visible"
}

function CloseChest() 
{
	$("#chest_opened_animation").style.visibility = "collapse"
}

GameUI.CustomUIConfig().OpenStoreGlobal = ToggleShop


GameUI.CustomUIConfig().OpenPanelBuyPass = function()
{
    let table = GetItemInfo(205)
    $("#info_item_buy").SetHasClass("IsChest", false)
    $("#ItemIconLarge").visible = true
    $("#info_item_buy").style.visibility = "visible"
    $("#ItemNameInfo").text = $.Localize("#" +  table[4] )
    $("#ItemInfoBody").style.flowChildren = "down"

    let Panel_for_desc = $.CreatePanel("Label", $("#ItemInfoBody"), "Panel_for_desc");
    Panel_for_desc.AddClass("Panel_for_desc");

    let Item_desc = $.CreatePanel("Label", Panel_for_desc, "Item_desc");
    Item_desc.AddClass("Item_desc");

    let str = table[4].replace(/[^a-zа-яё]/gi, '');
    Item_desc.text = $.Localize("#" + str + "_description" )

    if (table[4].indexOf("chest") == 0) 
    {
        $("#info_item_buy").SetHasClass("IsChest", true)
        let chest_table = GetChestInfo(Number(table[1]))
        let ChestItemPreview = $.CreatePanel("Panel", $("#ItemInfoBody"), "ChestItemPreview");
        ChestItemPreview.AddClass("ChestItemPreview");
        for (var i = 0; i <= Object.keys(Items_ALL).length; i++) 
        {
            if (Items_ALL[i])
            {
                CreateItemInChestPreview(ChestItemPreview, Items_ALL, i, chest_table)
            }
        }
        CreateItemCurrencyPreview(ChestItemPreview, chest_table[2][1], chest_table[2][3], chest_table[2][2])
    }

    let BuyItemPanel = $.CreatePanel("Panel", $("#ItemInfoBody"), "BuyItemPanel");
    BuyItemPanel.AddClass("BuyItemPanelInfo");

    let PriceLabel = $.CreatePanel("Label", BuyItemPanel, "PriceLabel");
    PriceLabel.AddClass("PriceLabelInfo");
    PriceLabel.text = $.Localize( "#shop_buy" )

    BuyItemPanel.SetPanelEvent("onactivate", function() 
    { 
        BuyItemFunction(table); 
        CloseItemInfo(); 
    });
}