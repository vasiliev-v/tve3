var parentHUDElements = $.GetContextPanel().GetParent().GetParent().GetParent().FindChild("HUDElements").FindChildTraverse("MenuButtons");
if ($("#InformationButton")) {
	if (parentHUDElements.FindChildTraverse("InformationButton")){
		$("#InformationButton").DeleteAsync( 0 );
	} else {
		$("#InformationButton").SetParent(parentHUDElements);
	}
}

var toggle = false;
var first_time = false;
var cooldown_panel = false
var current_sub_tab = "";

function ToggleInformation() {
    if (toggle === false) {
    	if (cooldown_panel == false) {
	        toggle = true;
	        if (first_time === false) {
	            first_time = true;
	            InitInformationPanels()
	            $("#InformationPanel").AddClass("sethidden");
	        }  
	        if ($("#InformationPanel").BHasClass("sethidden")) {
	            $("#InformationPanel").RemoveClass("sethidden");
	        }
	        $("#InformationPanel").AddClass("setvisible");
	        $("#InformationPanel").style.visibility = "visible"
	        cooldown_panel = true
	        $.Schedule( 0.503, function(){
	        	cooldown_panel = false
	        })
	    }
    } else {
    	if (cooldown_panel == false) {
	        toggle = false;
	        if ($("#InformationPanel").BHasClass("setvisible")) {
	            $("#InformationPanel").RemoveClass("setvisible");
	        }
	        $("#InformationPanel").AddClass("sethidden");
	        cooldown_panel = true
	        $.Schedule( 0.503, function(){
	        	cooldown_panel = false
	        	$("#InformationPanel").style.visibility = "collapse"
			})
		}
    }
}

// Я захотел автоматизировать весь процесс в javascript, чтоб ты не создавал кучу xml панелек и пытался в них разобраться
// Это массив кнопок слева

// Айди кнопки, заголовок(переменная addon_russia принимает br fontcolor итд), описание(переменная addon_russia принимает br fontcolor итд), иконка справа, айди панели с информацией
var information_buttons =
[
	["#information_button_1", "#button_title1", "#button_description1", "troll_icon", "information_panel_1"],
	["#information_button_2", "#button_title2", "#button_description2", "troll_icon", "information_panel_2"],
	["#information_button_3", "#button_title3", "#button_description3", "troll_icon", "information_panel_3"],
	["#information_button_4", "#button_title4", "#button_description4", "troll_icon", "information_panel_4"],
	["#information_button_5", "#button_title5", "#button_description5", "troll_icon", "information_panel_5"],
	["#information_button_6", "#button_title6", "#button_description6", "troll_icon", "information_panel_6"],
	["#information_button_7", "#button_title7", "#button_description7", "troll_icon", "information_panel_7"],
	["#information_button_8", "#button_title8", "#button_description8", "troll_icon", "information_panel_8"],
]

// Панели с информацией
// Айди панели ( Всегда в формате information_panel_число чтоб переключался работала), заголовок(переменная addon_russia принимает br fontcolor итд), сама информация(переменная addon_russia принимает br fontcolor итд), название видоса ( хранение в panorama/videos в папке game формат WEBM)

var information_panels = 
[
	["information_panel_1", "#Information_title_1", "#information_description1", "video_1"],
	["information_panel_2", "#Information_title_2", "#information_description2", "video_2"],
	["information_panel_3", "#Information_title_3", "#information_description3", "video_3"],
	["information_panel_4", "#Information_title_4", "#information_description4", "video_4"],
	["information_panel_5", "#Information_title_5", "#information_description5", "video_5"],
	["information_panel_6", "#Information_title_6", "#information_description6", "video_6"],
	["information_panel_7", "#Information_title_7", "#information_description7", "video_7"],
	["information_panel_8", "#Information_title_8", "#information_description8", "video_8"],
]


var current_list = 1
var max_list = information_panels.length

function InitInformationPanels()
{
	// создаем кнопки
	for (var i = 0; i < information_buttons.length; i++) {
		var ButtonMenu = $.CreatePanel("Panel", $("#MenuPanel"), information_buttons[i][0]);
		ButtonMenu.AddClass("ButtonMenu");

		var ButtonIcon = $.CreatePanel("Panel", ButtonMenu, "");
		ButtonIcon.AddClass("ButtonIcon");
		ButtonIcon.style.backgroundImage = 'url("file://{images}/custom_game/info/icons/' + information_buttons[i][3] + '.png")';
		ButtonIcon.backgroundSize = "100%"

		var TextButton = $.CreatePanel("Panel", ButtonMenu, "");
		TextButton.AddClass("TextButton");

		var ButtonTitle = $.CreatePanel("Label", TextButton, "");
		ButtonTitle.AddClass("ButtonTitle");
		ButtonTitle.html = true
		ButtonTitle.text = $.Localize(information_buttons[i][1])
		ButtonTitle.html = true 

		var ButtonDescription = $.CreatePanel("Label", TextButton, "");
		ButtonDescription.AddClass("ButtonDescription");
		ButtonDescription.html = true
		ButtonDescription.text = $.Localize(information_buttons[i][2])
		ButtonDescription.html = true 

		SetButton(ButtonMenu, i)
	}

	// Создаем окошки с информацией
	for (var i = 0; i < information_panels.length; i++) {
		var PanelInformation = $.CreatePanel("Panel", $("#MainPanel"), information_panels[i][0]);
		PanelInformation.AddClass("PanelInformation");

		var PanelInformationTitle = $.CreatePanel("Label", PanelInformation, "");
		PanelInformationTitle.AddClass("PanelInformationTitle");
		PanelInformationTitle.html = true
		PanelInformationTitle.text = $.Localize(information_panels[i][1])
		PanelInformationTitle.html = true 

		var PanelInformationDescription = $.CreatePanel("Label", PanelInformation, "");
		PanelInformationDescription.AddClass("PanelInformationDescription");
		PanelInformationDescription.html = true
		PanelInformationDescription.text = $.Localize(information_panels[i][2])
		PanelInformationDescription.html = true 
 
		var movie = $.CreatePanelWithProperties("Movie", PanelInformation, 'VideoInfo', { class:"VideoPanel", style:"width: 90%;horizontal-align: center;height: 400px;margin-top: 40px;border: 2px solid black;", src:"file://{resources}/videos/custom_game/"+information_panels[i][3]+".webm",  repeat:"true", hittest:"false", autoplay:"onload"});
		var NavigationControls = $.CreatePanel("Panel", PanelInformation,"");
		NavigationControls.AddClass("NavigationControls");

		var LeftControl = $.CreatePanel("Panel", NavigationControls, "");
		LeftControl.AddClass("LeftControl"); 
		LeftControl.SetPanelEvent("onactivate", function() { SwitchButtonBack() } );

		var RightControl = $.CreatePanel("Panel", NavigationControls, "");
		RightControl.AddClass("RightControl");
		RightControl.SetPanelEvent("onactivate", function() { SwitchButtonGo() } );


		if (i != 0)
		{
			PanelInformation.style.visibility = "collapse"
		}
	} 

}

function SwitchInfo(tab) 
{
	for (var i = 0; i < information_panels.length; i++) {
		let panel_info_close = $("#MainPanel").FindChildTraverse(information_panels[i][0])
		panel_info_close.style.visibility = "collapse";
		let panel_info_video_close = panel_info_close.FindChildTraverse("VideoInfo")
		panel_info_video_close.Stop()
	}

	let panel_info = $("#MainPanel").FindChildTraverse(tab)
	panel_info.style.visibility = "visible";

	let panel_info_video = $("#MainPanel").FindChildTraverse(tab).FindChildTraverse("VideoInfo")
	panel_info_video.Play()
}

function SetButton(panel, i)
{
	panel.SetPanelEvent("onactivate", function() {
	 	current_list = i + 1
		SwitchInfo(information_buttons[i][4]) 
	} );
}

function SwitchButtonBack()
{
	if ( current_list - 1 < 1)
	{
		current_list = max_list
	} else {
 		current_list = current_list - 1
	}
	SwitchInfo(information_buttons[current_list-1][4])
}

function SwitchButtonGo()
{
	if ( current_list + 1 > max_list)
	{
		current_list = 1
	} else {
		current_list = current_list + 1
	}
	SwitchInfo(information_buttons[current_list-1][4])
}




