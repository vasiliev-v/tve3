var ui = GameUI.CustomUIConfig();

function OpenSendResourcePanel(target_id)
{
    $("#SendResourceMain").SetHasClass("Open", true)
    $("#SendResourceMain").target_id = target_id
    let local_id = Players.GetLocalPlayer()

    let SliderGold = $("#SliderGold")
    SliderGold.min = 0;
	SliderGold.max = 75;
	SliderGold.value = 0;
    
    let SliderLumber = $("#SliderLumber")
    SliderLumber.min = 0;
	SliderLumber.max = 75;
	SliderLumber.value = 0;

    $("#FirstPlayerName").text = Players.GetPlayerName(local_id)
    $("#SecondPlayerName").text = Players.GetPlayerName(target_id)
}

function CloseSendPanel()
{
    $("#SendResourceMain").SetHasClass("Open", false)
}

function SliderGoldUpdater() 
{
    let local_id = Players.GetLocalPlayer()
    let SliderGold = $("#SliderGold")
    let CoinEntry = $("#CoinEntry")
    if (ui && ui.playerGold && ui.playerGold[local_id])
    {
        CoinEntry.text = Math.floor(Number(SliderGold.value) / 100 * Number(ui.playerGold[local_id]))
    }
    else
    {
        CoinEntry.text = "0"
    }
}

function SliderLumberUpdater() 
{
    let local_id = Players.GetLocalPlayer()
    let SliderLumber = $("#SliderLumber")
    let LumberEntry = $("#LumberEntry")
    if (ui && ui.playerLumber && ui.playerLumber[local_id])
    {
        LumberEntry.text = Math.floor(Number(SliderLumber.value) / 100 * Number(ui.playerLumber[local_id]))
    }
    else
    {
        LumberEntry.text = "0"
    }
}

function SendResource()
{
    let casterID = Players.GetLocalPlayer();
    let target = $("#SendResourceMain").target_id
    let CoinEntry = $("#CoinEntry")
    let LumberEntry = $("#LumberEntry")
    let gold = Number(CoinEntry.text) || 0;
    let lumber = Number(LumberEntry.text) || 0;
    GameEvents.SendCustomGameEventToServer('give_resources', {gold, lumber, target, casterID});
    CloseSendPanel()
}

function SendResourceAll()
{
    let casterID = Players.GetLocalPlayer();
    let target = $("#SendResourceMain").target_id
    let gold = ui.playerGold[casterID] || 0;
    let lumber = ui.playerLumber[casterID] || 0;
    GameEvents.SendCustomGameEventToServer('give_resources', {gold, lumber, target, casterID});
    CloseSendPanel()
}

GameUI.CustomUIConfig().OpenSendResourcePanelGlobal = OpenSendResourcePanel