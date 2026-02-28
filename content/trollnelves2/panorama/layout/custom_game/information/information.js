var information_panels = 
[
	["button_title1", "information_description1", "video_1"],
	["button_title2", "information_description2", "video_2"],
	["button_title3", "information_description3", "video_3"],
	["button_title4", "information_description4", "video_4"],
	["button_title5", "information_description5", "video_5"],
	["button_title6", "information_description6", "video_6"],
	["button_title7", "information_description7", "video_7"],
	["button_title8", "information_description8", "video_8"],
]

var INIT_PANEL = false
 
function Info_OpenPanel()
{
    let InformationPanel = $("#InformationPanel")
    InformationPanel.SetHasClass("Open", !InformationPanel.BHasClass("Open"))
    if (!INIT_PANEL)
    {
        INIT_PANEL = true
        InitInformationPanels()
    }
}

function Info_ClosePanel()
{
    let InformationPanel = $("#InformationPanel")
    if (InformationPanel.BHasClass("Open"))
    {
        InformationPanel.SetHasClass("Open", false)
    }
}

function InitInformationPanels()
{
    let GuidesPanels = $("#GuidesPanels")
	for (tbl_info of information_panels) 
    {
        let info_window = $.CreatePanel("Panel", GuidesPanels, "")
        info_window.AddClass("info_window")

        let info_button = $.CreatePanel("Panel", info_window, "")
        info_button.AddClass("info_button")

        let info_button_label = $.CreatePanel("Label", info_button, "")
        info_button_label.AddClass("info_button_label")
        info_button_label.text = $.Localize("#" + tbl_info[0])

        let info_button_arrow = $.CreatePanel("Panel", info_button, "")
        info_button_arrow.AddClass("info_button_arrow")

        info_button.SetPanelEvent("onactivate", function()
        {
            ToggleInformation(info_window);
        })

        let info_video_and_description = $.CreatePanel("Panel", info_window, "")
        info_video_and_description.AddClass("info_video_and_description")

        let info_description = $.CreatePanel("Label", info_video_and_description, "")
        info_description.AddClass("info_description")
        info_description.html = true
        info_description.text = $.Localize("#" + tbl_info[1])

        $.CreatePanel("Movie", info_video_and_description, 'VideoInfo', { style:"width:510px;height:298px;margin-left:16px;", class:"VideoPanel", src:"file://{resources}/videos/custom_game/"+tbl_info[2]+".webm", repeat:"true", hittest:"false", autoplay:"onload"});
	}
}

function ToggleInformation(info_window)
{
    info_window.SetHasClass("Opened", !info_window.BHasClass("Opened"))
}

GameUI.CustomUIConfig().OpenInfoGlobal = Info_OpenPanel
GameUI.CustomUIConfig().CloseInfoGlobal = Info_ClosePanel