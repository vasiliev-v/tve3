var GAME_SETUP_STATE = DOTA_GameState.DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP;
var LOADING_INPUT_BLOCKER_ID = 'SidebarAndBattleCupLayoutContainer';

// ==========================================
// 1. ЛОГИКА СОСТОЯНИЯ ЭКРАНА (Скрытие/Показ)
// ==========================================

function OpenExternalUrl(url) {
    $.DispatchEvent('ExternalBrowserGoToURL', url);
}

function IsWaitingForPlayers() {
    return Game.GameStateIsBefore(GAME_SETUP_STATE);
}

function FindLoadingPanel(panelId) {
    var panel = $.GetContextPanel();
    while (panel != null && panel.GetParent() != null) {
        panel = panel.GetParent();
    }

    var loadingRoot = (panel && panel.id === 'DotaLoadingScreen') ? panel : (panel ? panel.FindChildTraverse('DotaLoadingScreen') : null);
    return loadingRoot ? loadingRoot.FindChildTraverse(panelId) : null;
}

function DisableNativeLoadingInputBlocker() {
    var panel = FindLoadingPanel(LOADING_INPUT_BLOCKER_ID);
    if (panel) {
        panel.hittest = false;
        panel.hittestchildren = false;
    }
}

function SyncState() {
    // Если вам нужно временно включить вечный экран для верстки, 
    // закомментируйте нижнюю строку и раскомментируйте "var isVisible = true;"
    var isVisible = IsWaitingForPlayers(); 
    // var isVisible = true; 

    var root = $.GetContextPanel();
    root.hittest = isVisible;
    root.hittestchildren = isVisible;
    root.SetHasClass("IsVisible", isVisible);

    if (isVisible) {
        DisableNativeLoadingInputBlocker();
    }
}

// ==========================================
// 2. ЛОГИКА СЛАЙДЕРА СОВЕТОВ
// ==========================================

var TIPS_DATA = [
    {
        image: "file://{images}/custom_game/loading_screen/tips/root_glyph.png",
        text: "Старайтесь как можно чаще нажимать свои предметы для замедления фарма тролля!"
    },
    {
        image: "file://{images}/custom_game/loading_screen/tips/tip2.png", // Путь ко 2 картинке
        text: "Текст второго совета (замените меня в JS)."
    },
    {
        image: "file://{images}/custom_game/loading_screen/tips/tip3.png", // Путь к 3 картинке
        text: "Текст третьего совета (замените меня в JS)."
    },
    {
        image: "file://{images}/custom_game/loading_screen/tips/tip4.png", // Путь к 4 картинке
        text: "Текст четвертого совета (замените меня в JS)."
    }
];

var currentTipIndex = 0;
var isDotsInitialized = false;

function ChangeTip(offset) {
    currentTipIndex += offset;
    
    // Зацикливаем переключение слайдов
    if (currentTipIndex < 0) {
        currentTipIndex = TIPS_DATA.length - 1;
    } else if (currentTipIndex >= TIPS_DATA.length) {
        currentTipIndex = 0;
    }
    
    UpdateTipUI();
}

function InitializeDots() {
    var dotsContainer = $('#TipDotsContainer');
    if (!dotsContainer) return;
    
    // Очищаем контейнер от старых точек
    dotsContainer.RemoveAndDeleteChildren();

    for (var i = 0; i < TIPS_DATA.length; i++) {
        var dot = $.CreatePanel('Panel', dotsContainer, 'TipDot_' + i);
        dot.AddClass('TipDot');
        
        // Создаем замыкание, чтобы каждая точка переключала на свой индекс при клике
        (function(index) {
            dot.SetPanelEvent('onactivate', function() {
                currentTipIndex = index;
                UpdateTipUI();
            });
        })(i);
    }
    
    isDotsInitialized = true;
}

function UpdateTipUI() {
    // Инициализируем круги при первом вызове
    if (!isDotsInitialized) {
        InitializeDots();
    }

    var imgPanel = $('#TipImage');
    var textPanel = $('#TipText');
    var dotsContainer = $('#TipDotsContainer');
    
    if (imgPanel && textPanel) {
        imgPanel.SetImage(TIPS_DATA[currentTipIndex].image);
        textPanel.text = TIPS_DATA[currentTipIndex].text;
    }

    // Обновляем состояние кругов
    if (dotsContainer) {
        for (var i = 0; i < TIPS_DATA.length; i++) {
            var dot = dotsContainer.FindChildTraverse('TipDot_' + i);
            if (dot) {
                dot.SetHasClass('Active', i === currentTipIndex);
            }
        }
    }
}

// ==========================================
// 3. ЛОГИКА ПОИСКА ЧАТА
// ==========================================

function ChatUpdater() {
    GameUI.CustomUIConfig().FindLoadingChat = function() {
        GameUI.CustomUIConfig().LoadingChat = $.GetContextPanel().GetParent().FindChildTraverse("LoadingScreenChat");
    };
    
    $.Schedule(0.5, ChatUpdater);
}

// ==========================================
// ИНИЦИАЛИЗАЦИЯ ПРИ ЗАГРУЗКЕ
// ==========================================

(function() {
    // Подписываемся на смену статуса игры для скрытия экрана
    SyncState();
    GameEvents.Subscribe('game_rules_state_change', SyncState);

    // Запускаем скрипт поиска чата
    ChatUpdater();
    
    // Отрисовываем первый совет в слайдере и генерируем круги
    UpdateTipUI();
})();