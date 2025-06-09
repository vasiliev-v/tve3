function ChatUpdater()
{
    GameUI.CustomUIConfig().FindLoadingChat = function()
    {
        GameUI.CustomUIConfig().LoadingChat = $.GetContextPanel().GetParent().FindChildTraverse("LoadingScreenChat")
    } 
    $.Schedule(0.5, ChatUpdater)
}

ChatUpdater()