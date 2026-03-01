// @ts-nocheck
GameEvents.SubscribeProtected("show_flag_options", ShowFlagOptions);

function ShowFlagOptions(data) {
    const name = data["name"];
    const plID = data["id"];
    const casterID = data["casterID"];
    const text = "<b><font color='#FFD74B'>" + name + "</font></b> adds you to its private zone.";
    const yes_function = function () {
        GameEvents.SendCustomGameEventToServer("choose_flag_side", { vote: 1, playerID1: plID, casterID: casterID });
    };
    const no_function = function () {
        GameEvents.SendCustomGameEventToServer("choose_flag_side", { vote: 0, playerID1: plID, casterID: casterID });
    };
    CreatePanelNotificationWithButtons(text, yes_function, no_function);
}

GameEvents.SubscribeProtected("show_helper_options", ShowHelperOptions); // old useless
function ShowHelperOptions(data) {
    const text = "<b> Do you want to be a Wolf? </b>";
    const yes_function = function () {
        GameEvents.SendCustomGameEventToServer("choose_help_side", { team: 3 });
    };
    const no_function = function () {
        GameEvents.SendCustomGameEventToServer("choose_help_side", { team: 2 });
    };
    CreatePanelNotificationWithButtons(text, yes_function, no_function);
}

GameEvents.SubscribeProtected("show_helper_options2", ShowHelperOptions2); // old useless
function ShowHelperOptions2(data) {
    const yes_function = function () {

    };
    const no_function = function () {

    };
    // @ts-ignore - preserve legacy behavior (text is intentionally undefined here)
    CreatePanelNotificationWithButtons(text, yes_function, no_function);
}

GameEvents.SubscribeProtected("show_votekick_options", ShowKickOptions);
function ShowKickOptions(data) {
    const name = data["name"];
    const plID = data["id"];
    const casterID = data["casterID"];
    const text = "Votekick: " + "<b><font color='#FFD74B'>" + name + "</font></b>";
    const yes_function = function () {
        GameEvents.SendCustomGameEventToServer("choose_kick_side", { vote: 1, playerID1: plID, casterID: casterID });
    };
    const no_function = function () {
        GameEvents.SendCustomGameEventToServer("choose_kick_side", { vote: 0, playerID1: plID, casterID: casterID });
    };
    CreatePanelNotificationWithButtons(text, yes_function, no_function);
}

GameEvents.SubscribeProtected("show_notification_message_for_player", CreatePanelNotificationText);

function CreatePanelNotificationWithButtons(text, yes_function, no_function) {
    const panel_notifications = $.CreatePanel("Panel", $("#VotesNotifications"), "");
    panel_notifications.AddClass("panel_notifications");
    panel_notifications.AddClass("Open");

    const panel_notifications_BG = $.CreatePanel("Panel", panel_notifications, "");
    panel_notifications_BG.AddClass("panel_notifications_BG");

    const panel_notifications_close = $.CreatePanel("Panel", panel_notifications, "");
    panel_notifications_close.AddClass("panel_notifications_close");

    const panel_notifications_body = $.CreatePanel("Panel", panel_notifications, "");
    panel_notifications_body.AddClass("panel_notifications_body");

    const panel_notifications_timer_bg = $.CreatePanel("Panel", panel_notifications_body, "");
    panel_notifications_timer_bg.AddClass("panel_notifications_timer_bg");

    const panel_notifications_timer_label = $.CreatePanel("Label", panel_notifications_timer_bg, "panel_notifications_timer_label");
    panel_notifications_timer_label.AddClass("panel_notifications_timer_label");
    panel_notifications_timer_label.text = "30";

    const panel_notifications_body_text = $.CreatePanel("Label", panel_notifications_body, "");
    panel_notifications_body_text.AddClass("panel_notifications_body_text");
    panel_notifications_body_text.html = true;
    panel_notifications_body_text.text = text;

    const panel_notifications_buttons = $.CreatePanel("Panel", panel_notifications_body, "");
    panel_notifications_buttons.AddClass("panel_notifications_buttons");

    const panel_notifications_button_yes = $.CreatePanel("Panel", panel_notifications_buttons, "");
    panel_notifications_button_yes.AddClass("panel_notifications_button_yes");

    const panel_notifications_button_yes_label = $.CreatePanel("Label", panel_notifications_button_yes, "");
    panel_notifications_button_yes_label.AddClass("panel_notifications_button_yes_label");
    panel_notifications_button_yes_label.text = "Accept";

    const panel_notifications_button_no = $.CreatePanel("Panel", panel_notifications_buttons, "");
    panel_notifications_button_no.AddClass("panel_notifications_button_no");

    const panel_notifications_button_no_label = $.CreatePanel("Label", panel_notifications_button_no, "");
    panel_notifications_button_no_label.AddClass("panel_notifications_button_no_label");
    panel_notifications_button_no_label.text = "Cancel";

    panel_notifications_close.SetPanelEvent("onactivate", function () {
        if (panel_notifications.timer) {
            $.CancelScheduled(panel_notifications.timer);
        }
        panel_notifications.DeleteAsync(0);
    });

    panel_notifications_button_yes.SetPanelEvent("onactivate", function () {
        if (panel_notifications.timer) {
            $.CancelScheduled(panel_notifications.timer);
        }
        panel_notifications.DeleteAsync(0);
        yes_function();
    });

    panel_notifications_button_no.SetPanelEvent("onactivate", function () {
        if (panel_notifications.timer) {
            $.CancelScheduled(panel_notifications.timer);
        }
        panel_notifications.DeleteAsync(0);
        no_function();
    });

    panel_notifications.timer = $.Schedule(1, function () {
        PanelSchedule(30, panel_notifications);
    });
}

function CreatePanelNotificationText(data) {
    const panel_notifications = $.CreatePanel("Panel", $("#VotesNotifications"), "");
    panel_notifications.AddClass("panel_notifications");
    panel_notifications.AddClass("Open");

    const panel_notifications_BG = $.CreatePanel("Panel", panel_notifications, "");
    panel_notifications_BG.AddClass("panel_notifications_BG");

    const panel_notifications_close = $.CreatePanel("Panel", panel_notifications, "");
    panel_notifications_close.AddClass("panel_notifications_close");

    const panel_notifications_body = $.CreatePanel("Panel", panel_notifications, "");
    panel_notifications_body.AddClass("panel_notifications_body");

    const panel_notifications_body_text = $.CreatePanel("Label", panel_notifications_body, "");
    panel_notifications_body_text.AddClass("panel_notifications_body_text");
    panel_notifications_body_text.html = true;
    panel_notifications_body_text.text = $.Localize("#" + data.text);
    panel_notifications_body_text.AddClass("CenterText");

    panel_notifications_close.SetPanelEvent("onactivate", function () {
        if (panel_notifications.timer) {
            $.CancelScheduled(panel_notifications.timer);
        }
        panel_notifications.DeleteAsync(0);
    });
}

function PanelSchedule(time, panel_notifications) {
    if (!panel_notifications.IsValid()) {
        return;
    }
    time = time - 1;
    const panel_notifications_timer_label = panel_notifications.FindChildTraverse("panel_notifications_timer_label");
    if (panel_notifications_timer_label) {
        panel_notifications_timer_label.text = time;
    }
    if (time <= 0) {
        panel_notifications.DeleteAsync(0);
        return;
    }
    panel_notifications.timer = $.Schedule(1, function () {
        PanelSchedule(time, panel_notifications);
    });
}
