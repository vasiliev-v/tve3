"use strict";

function ChooseSide( teamNumber){
	var pID = Players.GetLocalPlayer();
	GameEvents.SendCustomGameEventToServer( "choose_help_side", { team:teamNumber, id:pID });
	$("#ChooseHelpContainer").style.visibility = "collapse";
}

function ShowHelperOptions(){
	$("#ChooseHelpContainer").style.visibility = "visible";
	$.Schedule(30,function(){
		$("#ChooseHelpContainer").style.visibility = "collapse";
	});
}

function ShowHelperOptions2(){
	$("#ChooseHelpContainer2").style.visibility = "visible";
	$.Schedule(30,function(){
		$("#ChooseHelpContainer2").style.visibility = "collapse";
	});
}

(function () {
	GameEvents.SubscribeProtected("show_helper_options", ShowHelperOptions);
	GameEvents.SubscribeProtected("show_helper_options2", ShowHelperOptions2);
})();