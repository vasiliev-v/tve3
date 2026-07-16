var cachedHud = null;
var cachedOverlays = {}; // Кэш для панелей оверлеев

function GetDotaHud() {
    if (cachedHud) return cachedHud; // Если уже нашли HUD, не ищем заново

    var panel = $.GetContextPanel();
    while (panel !== null && panel.id !== 'Hud') {
        panel = panel.GetParent();
    }
    
    if (panel) cachedHud = panel;
    return panel;
}

function UpdateSellOverlays() {
    var dotaHud = GetDotaHud();
    if (!dotaHud) {
        $.Schedule(0.1, UpdateSellOverlays);
        return;
    }

    var portraitUnit = Players.GetLocalPlayerPortraitUnit();

    for (var i = 0; i <= 8; i++) {
        var itemIndex = Entities.GetItemInSlot(portraitUnit, i);
        
        // КЭШИРОВАНИЕ: Ищем панели только один раз, если их еще нет в памяти
        if (!cachedOverlays[i]) {
            var slotPanel = dotaHud.FindChildTraverse("inventory_slot_" + i);
            if (slotPanel) {
                var overlay = slotPanel.FindChildTraverse("MarkForSellOverlay");
                if (overlay) {
                    cachedOverlays[i] = overlay; // Сохраняем найденный оверлей навсегда
                }
            }
        }

        // Используем закэшированную панель напрямую
        var overlayPanel = cachedOverlays[i];
        
        if (overlayPanel) {
            if (itemIndex !== -1) {
                // Читаем данные из NetTable
                var markData = CustomNetTables.GetTableValue("sell_items", itemIndex.toString());
                
                if (markData && markData.marked === 1) {
                    overlayPanel.style.opacity = "1.0";
                } else {
                    overlayPanel.style.opacity = null;
                }
            } else {
                overlayPanel.style.opacity = null;
            }
        }
    }

    $.Schedule(0.05, UpdateSellOverlays);
}

(function() {
    $.Schedule(0.5, UpdateSellOverlays); // Небольшая задержка на старте, чтобы HUD успел прогрузиться
})();