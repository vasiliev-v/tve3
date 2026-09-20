// UX only. The web API still authorizes every request independently.
(function () {
    var config = GameUI.CustomUIConfig();
    var controls = [];

    config.IsRestrictedClient = function () {
        var state = CustomNetTables.GetTableValue("Shop", "restricted_client");
        return !!state && (state.isRestrictedClient === true || state.isRestrictedClient === 1);
    };

    // Native inventory slots use this directly because their contents can change.
    config.SetWriteControlRestricted = function (panel, restricted) {
        if (!panel || !panel.IsValid()) return;
        if (restricted) {
            if (!panel.__restrictedClientOriginal) {
                panel.__restrictedClientOriginal = {
                    enabled: panel.enabled,
                    opacity: panel.style.opacity,
                    saturation: panel.style.saturation
                };
            }
            panel.enabled = false;
            panel.style.opacity = "0.35";
            panel.style.saturation = "0";
        } else if (panel.__restrictedClientOriginal) {
            var original = panel.__restrictedClientOriginal;
            panel.enabled = original.enabled;
            panel.style.opacity = original.opacity;
            panel.style.saturation = original.saturation;
            delete panel.__restrictedClientOriginal;
        }
    };

    config.RegisterWriteControl = function (panel) {
        if (!panel || !panel.IsValid()) return;
        controls = controls.filter(function (control) { return control.IsValid(); });
        if (controls.indexOf(panel) === -1) controls.push(panel);
        config.SetWriteControlRestricted(panel, config.IsRestrictedClient());
    };

    CustomNetTables.SubscribeNetTableListener("Shop", function (table, key) {
        if (key !== "restricted_client") return;
        controls = controls.filter(function (control) { return control.IsValid(); });
        controls.forEach(function (panel) {
            config.SetWriteControlRestricted(panel, config.IsRestrictedClient());
        });
    });
})();
