// @ts-nocheck
function GetDotaHud() {
    let hPanel = $.GetContextPanel();

    while (hPanel && hPanel.id !== "Hud") {
        hPanel = hPanel.GetParent();
    }

    if (!hPanel) {
        throw new Error("Could not find Hud root from panel with id: " + $.GetContextPanel().id);
    }

    return hPanel;
}

function FindDotaHudElement(sId) {
    return GetDotaHud().FindChildTraverse(sId);
}

function ConvertTimeMinutes(time) {
    const min = Math.trunc(time / 60);
    const sec_n = time - 60 * min;
    let sec = String(Math.trunc(sec_n));

    if (sec_n < 10) {
        sec = "0" + sec;
    }

    return min + ":" + sec;
}
