// @ts-nocheck
var sendResourceUi = GameUI.CustomUIConfig();

function OpenSendResourcePanel(target_id) {
    $("#SendResourceMain").SetHasClass("Open", true);
    $("#SendResourceMain").target_id = target_id;
    const local_id = Players.GetLocalPlayer();

    const SliderGold = $("#SliderGold");
    SliderGold.min = 0;
    SliderGold.max = 75;
    SliderGold.value = 0;

    const SliderLumber = $("#SliderLumber");
    SliderLumber.min = 0;
    SliderLumber.max = 75;
    SliderLumber.value = 0;

    $("#FirstPlayerName").text = Players.GetPlayerName(local_id);
    $("#SecondPlayerName").text = Players.GetPlayerName(target_id);
}

function CloseSendPanel() {
    $("#SendResourceMain").SetHasClass("Open", false);
}

function SliderGoldUpdater() {
    const local_id = Players.GetLocalPlayer();
    const SliderGold = $("#SliderGold");
    const CoinEntry = $("#CoinEntry");
    if (sendResourceUi && sendResourceUi.playerGold && sendResourceUi.playerGold[local_id]) {
        CoinEntry.text = Math.floor(Number(SliderGold.value) / 100 * Number(sendResourceUi.playerGold[local_id]));
    } else {
        CoinEntry.text = "0";
    }
}

function SliderLumberUpdater() {
    const local_id = Players.GetLocalPlayer();
    const SliderLumber = $("#SliderLumber");
    const LumberEntry = $("#LumberEntry");
    if (sendResourceUi && sendResourceUi.playerLumber && sendResourceUi.playerLumber[local_id]) {
        LumberEntry.text = Math.floor(Number(SliderLumber.value) / 100 * Number(sendResourceUi.playerLumber[local_id]));
    } else {
        LumberEntry.text = "0";
    }
}

function SendResourcePanel_SendResource() {
    const casterID = Players.GetLocalPlayer();
    const target = $("#SendResourceMain").target_id;
    const CoinEntry = $("#CoinEntry");
    const LumberEntry = $("#LumberEntry");
    const gold = Number(CoinEntry.text) || 0;
    const lumber = Number(LumberEntry.text) || 0;
    GameEvents.SendCustomGameEventToServer("give_resources", { gold, lumber, target, casterID });
    CloseSendPanel();
}

function SendResourceAll() {
    const casterID = Players.GetLocalPlayer();
    const target = $("#SendResourceMain").target_id;
    const gold = sendResourceUi.playerGold[casterID] || 0;
    const lumber = sendResourceUi.playerLumber[casterID] || 0;
    GameEvents.SendCustomGameEventToServer("give_resources", { gold, lumber, target, casterID });
    CloseSendPanel();
}

GameUI.CustomUIConfig().OpenSendResourcePanelGlobal = OpenSendResourcePanel;
