GameEvents.SubscribeProtected("show_flag_options", ShowFlagOptions);

function ShowFlagOptions(data)
{
    let name = data["name"];
	let plID = data["id"];
	let casterID = data["casterID"];
    let text = "<b><font color='#FFD74B'>"+name+"</font></b> adds you to its private zone."
    let yes_function = function()
    {
        GameEvents.SendCustomGameEventToServer( "choose_flag_side", { vote:1, playerID1:plID, casterID:casterID });
    }
    let no_function = function()
    {
        GameEvents.SendCustomGameEventToServer( "choose_flag_side", { vote:0, playerID1:plID, casterID:casterID });
    }
    CreatePanelNotificationWithButtons(text, yes_function, no_function)
}

GameEvents.SubscribeProtected("show_helper_options", ShowHelperOptions); // old useless
function ShowHelperOptions(data)
{
    let text = "<b> Do you want to be a Wolf? </b>"
    let yes_function = function()
    {
        GameEvents.SendCustomGameEventToServer( "choose_help_side", { team: 3});
    }
    let no_function = function()
    {
        GameEvents.SendCustomGameEventToServer( "choose_help_side", { team: 2});
    }
    CreatePanelNotificationWithButtons(text, yes_function, no_function)
}

GameEvents.SubscribeProtected("show_helper_options2", ShowHelperOptions2); // old useless
function ShowHelperOptions2(data)
{
    let yes_function = function()
    {
        
    }
    let no_function = function()
    {
        
    }
    CreatePanelNotificationWithButtons(text, yes_function, no_function)
}

GameEvents.SubscribeProtected("show_votekick_options", ShowKickOptions);
function ShowKickOptions(data)
{
    let name = data["name"];
	let plID = data["id"];
	let casterID = data["casterID"];
    let text = "Votekick: " + "<b><font color='#FFD74B'>"+name+"</font></b>";
    let yes_function = function()
    {
        GameEvents.SendCustomGameEventToServer( "choose_kick_side", { vote:1, playerID1:plID,casterID:casterID });
    }
    let no_function = function()
    {
        GameEvents.SendCustomGameEventToServer( "choose_kick_side", { vote:0, playerID1:plID,casterID:casterID });
    }
    CreatePanelNotificationWithButtons(text, yes_function, no_function)
}

GameEvents.SubscribeProtected("show_notification_message_for_player", CreatePanelNotificationText);

function CreatePanelNotificationWithButtons(text, yes_function, no_function)
{
    let panel_notifications = $.CreatePanel("Panel", $("#VotesNotifications"), "")
    panel_notifications.AddClass("panel_notifications")
    panel_notifications.AddClass("Open")

    let panel_notifications_BG = $.CreatePanel("Panel", panel_notifications, "")
    panel_notifications_BG.AddClass("panel_notifications_BG")

    let panel_notifications_close = $.CreatePanel("Panel", panel_notifications, "")
    panel_notifications_close.AddClass("panel_notifications_close")

    let panel_notifications_body = $.CreatePanel("Panel", panel_notifications, "")
    panel_notifications_body.AddClass("panel_notifications_body")

    let panel_notifications_timer_bg = $.CreatePanel("Panel", panel_notifications_body, "")
    panel_notifications_timer_bg.AddClass("panel_notifications_timer_bg")

    let panel_notifications_timer_label = $.CreatePanel("Label", panel_notifications_timer_bg, "panel_notifications_timer_label")
    panel_notifications_timer_label.AddClass("panel_notifications_timer_label")
    panel_notifications_timer_label.text = "30"

    let panel_notifications_body_text = $.CreatePanel("Label", panel_notifications_body, "")
    panel_notifications_body_text.AddClass("panel_notifications_body_text")
    panel_notifications_body_text.html = true
    panel_notifications_body_text.text = text

    let panel_notifications_buttons = $.CreatePanel("Panel", panel_notifications_body, "")
    panel_notifications_buttons.AddClass("panel_notifications_buttons")

    let panel_notifications_button_yes = $.CreatePanel("Panel", panel_notifications_buttons, "")
    panel_notifications_button_yes.AddClass("panel_notifications_button_yes")

    let panel_notifications_button_yes_label = $.CreatePanel("Label", panel_notifications_button_yes, "")
    panel_notifications_button_yes_label.AddClass("panel_notifications_button_yes_label")
    panel_notifications_button_yes_label.text = "Принять"

    let panel_notifications_button_no = $.CreatePanel("Panel", panel_notifications_buttons, "")
    panel_notifications_button_no.AddClass("panel_notifications_button_no")

    let panel_notifications_button_no_label = $.CreatePanel("Label", panel_notifications_button_no, "")
    panel_notifications_button_no_label.AddClass("panel_notifications_button_no_label")
    panel_notifications_button_no_label.text = "Отказать"
    
    panel_notifications_close.SetPanelEvent("onactivate", function()
    {
        if (panel_notifications.timer)
        {
            $.CancelScheduled(panel_notifications.timer)
        }
        panel_notifications.DeleteAsync(0)
    })

    panel_notifications_button_yes.SetPanelEvent("onactivate", function()
    {
        if (panel_notifications.timer)
        {
            $.CancelScheduled(panel_notifications.timer)
        }
        panel_notifications.DeleteAsync(0)
        yes_function()
    })

    panel_notifications_button_no.SetPanelEvent("onactivate", function()
    {
        if (panel_notifications.timer)
        {
            $.CancelScheduled(panel_notifications.timer)
        }
        panel_notifications.DeleteAsync(0)
        no_function()
    })

    panel_notifications.timer = $.Schedule(1, function()
    {
        PanelSchedule(30, panel_notifications)
    })
}

function CreatePanelNotificationText(data)
{
    let panel_notifications = $.CreatePanel("Panel", $("#VotesNotifications"), "")
    panel_notifications.AddClass("panel_notifications")
    panel_notifications.AddClass("Open")

    let panel_notifications_BG = $.CreatePanel("Panel", panel_notifications, "")
    panel_notifications_BG.AddClass("panel_notifications_BG")

    let panel_notifications_close = $.CreatePanel("Panel", panel_notifications, "")
    panel_notifications_close.AddClass("panel_notifications_close")

    let panel_notifications_body = $.CreatePanel("Panel", panel_notifications, "")
    panel_notifications_body.AddClass("panel_notifications_body")

    let panel_notifications_body_text = $.CreatePanel("Label", panel_notifications_body, "")
    panel_notifications_body_text.AddClass("panel_notifications_body_text")
    panel_notifications_body_text.html = true
    panel_notifications_body_text.text = $.Localize("#" + data.text)
    panel_notifications_body_text.AddClass("CenterText")

    panel_notifications_close.SetPanelEvent("onactivate", function()
    {
        if (panel_notifications.timer)
        {
            $.CancelScheduled(panel_notifications.timer)
        }
        panel_notifications.DeleteAsync(0)
    })
}

function PanelSchedule(time, panel_notifications)
{
    if (!panel_notifications.IsValid())
    {
        return
    }
    time = time - 1
    let panel_notifications_timer_label = panel_notifications.FindChildTraverse("panel_notifications_timer_label")
    if (panel_notifications_timer_label)
    {
        panel_notifications_timer_label.text = time
    }
    if (time <= 0)
    {
        panel_notifications.DeleteAsync(0)
        return
    }
    panel_notifications.timer = $.Schedule(1, function()
    {
        PanelSchedule(time, panel_notifications)
    })
}