// @ts-nocheck
"use strict";

var resourceUi = GameUI.CustomUIConfig();
(function () {
    resourceUi.playerGold = [];
    resourceUi.playerLumber = [];
    resourceUi.playerFood = [];
    resourceUi.playerMaxFood = [];
    //  //$.Msg("Initializing resource.js... resourceUi: ", resourceUi);
}());

function OnPlayerLumberChanged(args) {
    // //$.Msg("Player lumber changed: ", args);
    const playerID = args.playerID;
    const lumber = args.lumber;
    resourceUi.playerLumber[playerID] = lumber;
    UpdateLumberValue();
}

function UpdateLumberValue() {
    const playerID = Players.GetLocalPlayer();
    $("#LumberText").text = FormatNumberWithCommas(resourceUi.playerLumber[playerID]);
}

function OnPlayerGoldChanged(args) {
    // //$.Msg("Player gold changed: ", args);
    const playerID = args.playerID;
    const gold = args.gold;
    resourceUi.playerGold[playerID] = gold;
    UpdateGoldValue();
}

function UpdateGoldValue() {
    const playerID = Players.GetLocalPlayer();
    $("#GoldText").text = FormatNumberWithCommas(resourceUi.playerGold[playerID]);
}

function OnPlayerFoodChanged(args) {
    //  //$.Msg("Player food changed: ", args);
    const playerID = args.playerID;
    const food = args.food;
    const maxFood = args.maxFood;
    resourceUi.playerFood[playerID] = food;
    resourceUi.playerMaxFood[playerID] = maxFood;
    UpdateFoodValue();
}

function OnPlayerWispChanged(args) {
    // //$.Msg("Player wisp changed: ", args);
    // var playerID = args.playerID;
    // var wisp = args.wisp;
    // var maxWisp = args.maxWisp;
    //  resourceUi.playerWisp[playerID] = wisp;
    // resourceUi.playerMaxWisp[playerID] = maxWisp;
    //  UpdateWispValue();
}

function OnPlayerMineChanged(args) {
    // //$.Msg("Player wisp changed: ", args);
    // var playerID = args.playerID;
    // var wisp = args.wisp;
    // var maxWisp = args.maxWisp;
    //  resourceUi.playerWisp[playerID] = wisp;
    // resourceUi.playerMaxWisp[playerID] = maxWisp;
    //  UpdateWispValue();
}

function UpdateFoodValue() {
    const playerID = Players.GetLocalPlayer();
    const food = resourceUi.playerFood[playerID];
    const maxFood = resourceUi.playerMaxFood[playerID];
    $("#CheeseText").text = food + "/" + maxFood;
}

function UpdateWispValue() {
    // var playerID = Players.GetLocalPlayer();
    // var wisp = resourceUi.playerWisp[playerID];
    // var maxWisp = resourceUi.playerMaxWisp[playerID];
    // $('#CheeseText').text = wisp + "/" + maxWisp;
}

function OnPlayerLumberPriceChanged(args) {
    const lumberPrice = args.lumberPrice;
    const lumberSell = args.lumberSell;
    $("#ResourceChangeInfoGold").text = "<font color='#FFD74B'>" + FormatNumberWithCommas(lumberPrice) + "</font> -> " + "<font color='#23BD33'>10</font>";
    $("#ResourceChangeInfoLumber").text = "<font color='#23BD33'>10</font>" + " -> <font color='#FFD74B'>" + FormatNumberWithCommas(lumberSell) + "</font>";
}

var lumberPopupSchedules = {};
var lumberPopupColor = [10, 200, 90];

function TreeWispHarvestStarted(args) {
    // //$.Msg("Tree wisp harvest started: ", args);
    PopupNumbersInterval(lumberPopupSchedules, args.entityIndex, args.amount, args.interval, lumberPopupColor, 0, null, args.statusAnim);
}

function TreeWispHarvestStopped(args) {
    //   //$.Msg("Tree wisp harvest stopped: ", args);
    StopNumberPopupInterval(lumberPopupSchedules, args.entityIndex);
}

var goldPopupSchedules = {};
var goldPopupColor = [255, 200, 33];

function GoldGainStarted(args) {
    // //$.Msg("Gold gain started: ", args);
    PopupNumbersInterval(goldPopupSchedules, args.entityIndex, args.amount, args.interval, goldPopupColor, 0, null, args.statusAnim);
}

function GoldGainStopped(args) {
    // //$.Msg("Gold gain stopped: ", args);
    StopNumberPopupInterval(goldPopupSchedules, args.entityIndex);
}

function PopupNumbersInterval(schedulesArray, entityIndex, amount, interval, color, presymbol, postsymbol, statusAnim) {
    schedulesArray[entityIndex] = $.Schedule(interval, function PopupNumberInterval() {
        if (statusAnim == 0 || statusAnim == null || statusAnim == "") {
            PopupNumbers(entityIndex, "damage", color, 3, amount, presymbol, postsymbol);
        }
        schedulesArray[entityIndex] = $.Schedule(interval, PopupNumberInterval);
    });
}

function StopNumberPopupInterval(schedulesArray, entityIndex) {
    $.CancelScheduled(schedulesArray[entityIndex]);
}

// -- Customizable version.
function PopupNumbers(entityIndex, pfx, color, lifetime, number, presymbol, postsymbol) {
    const pfxPath = "particles/msg_fx/msg_" + pfx + ".vpcf";
    const pidx = Particles.CreateParticle(pfxPath, ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, entityIndex);

    let digits = 0;
    if (number != null) {
        digits = number.toString().length;
    }
    if (presymbol != null) {
        digits++;
    }
    if (postsymbol != null) {
        digits++;
    }
    Particles.SetParticleControl(pidx, 1, [presymbol, number, postsymbol]);
    Particles.SetParticleControl(pidx, 2, [lifetime, digits, 0]);
    Particles.SetParticleControl(pidx, 3, color);
    Particles.ReleaseParticleIndex(pidx);
}

function PlayerPickedHero(args) {
    // $.Msg("Player picked hero: ", args);
    // Ignoring args because it doesn't give player id (args.player gives playerID + 1 or is it some user id stuff?)
    // Better be safe and just get local player id.
    const localId = Players.GetLocalPlayer();
    const hero = Players.GetPlayerSelectedHero(localId);
    const panelVisibility = hero === "npc_dota_hero_treant" ? "visible" : "collapse";
    $("#CheesePanel").style.visibility = panelVisibility;
    $("#ChangeResourcePanelFirst").style.visibility = panelVisibility;
    $("#ChangeResourcePanelSecond").style.visibility = panelVisibility;
}

(function () {
    GameEvents.SubscribeProtected("player_lumber_changed", OnPlayerLumberChanged);
    GameEvents.SubscribeProtected("player_custom_gold_changed", OnPlayerGoldChanged);
    GameEvents.SubscribeProtected("player_food_changed", OnPlayerFoodChanged);
    GameEvents.SubscribeProtected("player_lumber_price_changed", OnPlayerLumberPriceChanged);
    GameEvents.SubscribeProtected("tree_wisp_harvest_start", TreeWispHarvestStarted);
    GameEvents.SubscribeProtected("tree_wisp_harvest_stop", TreeWispHarvestStopped);
    GameEvents.SubscribeProtected("gold_gain_start", GoldGainStarted);
    GameEvents.SubscribeProtected("gold_gain_stop", GoldGainStopped);
    GameEvents.SubscribeProtected("player_wisp_changed", OnPlayerWispChanged);
    GameEvents.SubscribeProtected("player_mine_changed", OnPlayerMineChanged);
    GameEvents.Subscribe("dota_player_pick_hero", PlayerPickedHero);
    GameEvents.Subscribe("dota_player_team_changed", PlayerPickedHero);
})();
