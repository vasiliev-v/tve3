var GAME_SETUP_STATE = DOTA_GameState.DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP;
var LOADING_INPUT_BLOCKER_ID = 'SidebarAndBattleCupLayoutContainer';

// ==========================================
// 1. ЛОГИКА СОСТОЯНИЯ ЭКРАНА
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
    // Проверяем реальное состояние игры, а не ставим true жестко
    var isVisible = IsWaitingForPlayers(); 
    
    var root = $.GetContextPanel();
    if (root) {
        root.hittest = isVisible;
        root.hittestchildren = isVisible;
        root.SetHasClass("IsVisible", isVisible);
    }

    if (isVisible) {
        DisableNativeLoadingInputBlocker();
    }
}

// ==========================================
// 2. ЛОГИКА СЛАЙДЕРА СОВЕТОВ С АНИМАЦИЕЙ
// ==========================================

var TIPS_DATA = [
    {
        video: "file://{resources}/videos/custom_game/video_1.webm",
        text: "#loading_tip_1" // Используем токен локализации
    },
    {
        video: "file://{resources}/videos/custom_game/video_2.webm",
        text: "#loading_tip_2"
    },
    {
        video: "file://{resources}/videos/custom_game/video_9.webm", 
        text: "#loading_tip_3"
    },
    {
        video: "file://{resources}/videos/custom_game/video_8.webm",
        text: "#loading_tip_4"
    }
];

var currentTipIndex = 0;
var isDotsInitialized = false;
var isAnimating = false;

// Измененная функция переключения
function ChangeTip(offset) {
    if (isAnimating) return; // Блокируем спам кликами во время анимации
    Game.EmitSound("General.buttonclick"); // Звук клика

    var newIndex = currentTipIndex + offset;
    
    if (newIndex < 0) {
        newIndex = TIPS_DATA.length - 1;
    } else if (newIndex >= TIPS_DATA.length) {
        newIndex = 0;
    }
    
    // offset > 0 значит листаем вперед (смахиваем влево)
    AnimateToTip(newIndex, offset > 0);
}

// Главная логика анимации
function AnimateToTip(newIndex, slideLeft) {
    var contentPanel = $('#TipContent');
    if (!contentPanel) {
        // Фоллбэк, если панели нет
        currentTipIndex = newIndex;
        UpdateTipUI();
        return;
    }

    isAnimating = true;

    // Шаг 1: Убираем текущий слайд
    if (slideLeft) contentPanel.AddClass('SlideOutLeft');
    else contentPanel.AddClass('SlideOutRight');

    // Ждем 0.25 сек, пока он уедет
    $.Schedule(0.25, function() {
        currentTipIndex = newIndex;
        UpdateTipUI(); // Меняем картинку и текст пока панель прозрачна
        
        contentPanel.RemoveClass('SlideOutLeft');
        contentPanel.RemoveClass('SlideOutRight');
        
        // Шаг 2: Показываем новый слайд с противоположной стороны
        if (slideLeft) contentPanel.AddClass('SlideInRight');
        else contentPanel.AddClass('SlideInLeft');

        // Ждем 0.25 сек, пока он появится
        $.Schedule(0.25, function() {
            contentPanel.RemoveClass('SlideInRight');
            contentPanel.RemoveClass('SlideInLeft');
            isAnimating = false; // Разблокируем переключение
        });
    });
}

function InitializeDots() {
    var dotsContainer = $('#TipDotsContainer');
    if (!dotsContainer) return;
    
    dotsContainer.RemoveAndDeleteChildren();

    for (var i = 0; i < TIPS_DATA.length; i++) {
        var dot = $.CreatePanel('Panel', dotsContainer, 'TipDot_' + i);
        dot.AddClass('TipDot');
        
        (function(index) {
            dot.SetPanelEvent('onactivate', function() {
                if (isAnimating || currentTipIndex === index) return;
                Game.EmitSound("General.buttonclick");
                // Определяем направление анимации в зависимости от того, куда кликнули
                AnimateToTip(index, index > currentTipIndex);
            });
        })(i);
    }
    
    isDotsInitialized = true;
}

function UpdateTipUI() {
    if (!isDotsInitialized) {
        InitializeDots();
    }

    var imgPanel = $('#TipImage');
    var videoPanel = $('#TipVideo');
    var textPanel = $('#TipText');
    var dotsContainer = $('#TipDotsContainer');
    
    if (textPanel) {
        // Пропускаем токен через $.Localize(), чтобы получить текст на языке клиента игрока
        textPanel.text = $.Localize(TIPS_DATA[currentTipIndex].text);
    }

    var currentTip = TIPS_DATA[currentTipIndex];

    if (currentTip.video) {
        if (videoPanel) {
            videoPanel.SetMovie(currentTip.video);
            videoPanel.visible = true;

            // Проверяем, является ли текущее видео роликом Дискорда
            if (currentTip.video.indexOf("video_8.webm") !== -1) {
                videoPanel.hittest = true; // Разрешаем клики по видео
                videoPanel.SetPanelEvent('onactivate', function() {
                    Game.EmitSound("General.buttonclick");
                    OpenExternalUrl("https://discord.gg/tve4");
                });
            } else {
                videoPanel.hittest = false; // Отключаем клики для других видео
                videoPanel.ClearPanelEvent('onactivate');
            }
        }
        if (imgPanel) {
            imgPanel.visible = false;
        }
    } else {
        if (imgPanel) {
            imgPanel.SetImage(currentTip.image);
            imgPanel.visible = true;
        }
        if (videoPanel) {
            videoPanel.SetMovie("");
            videoPanel.visible = false;
            videoPanel.hittest = false;
            videoPanel.ClearPanelEvent('onactivate');
        }
    }

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
    SyncState();
    GameEvents.Subscribe('game_rules_state_change', SyncState);
    ChatUpdater();
    UpdateTipUI();
})();