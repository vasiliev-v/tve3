var GAME_SETUP_STATE = DOTA_GameState.DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP;
var LOADING_INPUT_BLOCKER_ID = 'SidebarAndBattleCupLayoutContainer';

// ==========================================
// ЛОГИКА КЛИКАБЕЛЬНОСТИ И СОСТОЯНИЯ ЭКРАНА
// ==========================================

// Открытие внешних ссылок
function OpenExternalUrl(url) {
    $.DispatchEvent('ExternalBrowserGoToURL', url);
}

// Проверка фазы игры
function IsWaitingForPlayers() {
    return Game.GameStateIsBefore(GAME_SETUP_STATE);
}

// Поиск корневой панели загрузочного экрана (рекурсивный обход вверх)
function FindLoadingPanel(panelId) {
    var panel = $.GetContextPanel();
    while (panel != null && panel.GetParent() != null) {
        panel = panel.GetParent();
    }

    var loadingRoot = (panel && panel.id === 'DotaLoadingScreen') ? panel : (panel ? panel.FindChildTraverse('DotaLoadingScreen') : null);
    return loadingRoot ? loadingRoot.FindChildTraverse(panelId) : null;
}

// Отключение невидимой панели Valve, которая блокирует клики
function DisableNativeLoadingInputBlocker() {
    var panel = FindLoadingPanel(LOADING_INPUT_BLOCKER_ID);
    if (panel) {
        panel.hittest = false;
        panel.hittestchildren = false;
    }
}

// Обновление состояния видимости и кликабельности
function SyncState() {
    var isVisible = IsWaitingForPlayers();
    var root = $.GetContextPanel();

    // Управляем кликабельностью
    root.hittest = isVisible;
    root.hittestchildren = isVisible;
    
    // Добавляем класс для CSS анимаций
    root.SetHasClass("IsVisible", isVisible);

    if (isVisible) {
        DisableNativeLoadingInputBlocker();
    }
}

// ==========================================
// ЛОГИКА ПОИСКА ЧАТА (Ваш код)
// ==========================================

function ChatUpdater() {
    GameUI.CustomUIConfig().FindLoadingChat = function() {
        GameUI.CustomUIConfig().LoadingChat = $.GetContextPanel().GetParent().FindChildTraverse("LoadingScreenChat");
    };
    
    $.Schedule(0.5, ChatUpdater);
}

// ==========================================
// ИНИЦИАЛИЗАЦИЯ
// ==========================================

(function() {
    // 1. Инициализируем UI загрузочного экрана и подписываемся на смену фазы игры
    SyncState();
    GameEvents.Subscribe('game_rules_state_change', SyncState);

    // 2. Запускаем ваш цикл поиска панели чата
    ChatUpdater();
})();