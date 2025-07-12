if setup_state_lib == nil then
    _G.setup_state_lib = class({})
end

function setup_state_lib:SetNextStage()
    if setup_state_lib.StageQueue[setup_state_lib.CURRENT_QUEUE_STAGE] then
        setup_state_lib.StageQueue[setup_state_lib.CURRENT_QUEUE_STAGE]()
        setup_state_lib.CURRENT_QUEUE_STAGE = setup_state_lib.CURRENT_QUEUE_STAGE + 1
    else
        GameRules:FinishCustomGameSetup()
    end
end

function setup_state_lib:SetupStartMapVotes()
    local THIS_STAGE_TIMER = 30
    --if IsInToolsMode() then
    --    THIS_STAGE_TIMER = 10
    --end
    local TIMER_STAGE = THIS_STAGE_TIMER + 1
    local TIMER_STAGE_MAX = THIS_STAGE_TIMER
    CustomGameEventManager:Send_ServerToAllClients("troll_elves_init_stage_screen", {})
    Timers:CreateTimer(FrameTime(), function()
        TIMER_STAGE = TIMER_STAGE - 1
        CustomGameEventManager:Send_ServerToAllClients("troll_elves_init_stage_screen", {})
        CustomGameEventManager:Send_ServerToAllClients("troll_elves_init_stage_select_map", {maps = map_system.MAPS_LIST_G})
        CustomGameEventManager:Send_ServerToAllClients("troll_elves_phase_time", {time = TIMER_STAGE, max_time = TIMER_STAGE_MAX, stage = 1})
        if TIMER_STAGE <= 0 then
            BuildingHelper:UpdateMapStage()
            setup_state_lib:SetNextStage()
            return
        end
        return 1
    end)
end

function setup_state_lib:SetupStartSelectedRole()
    local THIS_STAGE_TIMER = 999
    --if IsInToolsMode() then
    --    THIS_STAGE_TIMER = 1
   -- end
    local TIMER_STAGE = THIS_STAGE_TIMER + 1
    local TIMER_STAGE_MAX = THIS_STAGE_TIMER
    CustomGameEventManager:Send_ServerToAllClients("troll_elves_init_stage_screen", {})
    Timers:CreateTimer(0.1, function()
        TIMER_STAGE = TIMER_STAGE - 1
        CustomGameEventManager:Send_ServerToAllClients("troll_elves_init_stage_screen", {})
        CustomGameEventManager:Send_ServerToAllClients("troll_elves_init_stage_select_role", {})
        CustomGameEventManager:Send_ServerToAllClients("troll_elves_phase_time", {time = TIMER_STAGE, max_time = TIMER_STAGE_MAX, stage = 2, map = GameRules.MapName})
        if TIMER_STAGE <= 0 then
            SetRoles()
            setup_state_lib:SetNextStage()
            return
        end
        return 1
    end)
end

function setup_state_lib:SetupStartSelectPerks()
    local THIS_STAGE_TIMER = 30
    --if IsInToolsMode() then
    --    THIS_STAGE_TIMER = 10
    --end
    local TIMER_STAGE = THIS_STAGE_TIMER + 1
    local TIMER_STAGE_MAX = THIS_STAGE_TIMER
    CustomGameEventManager:Send_ServerToAllClients("troll_elves_init_stage_screen", {})
    Timers:CreateTimer(0.1, function()
        TIMER_STAGE = TIMER_STAGE - 1
        CustomGameEventManager:Send_ServerToAllClients("troll_elves_init_stage_screen", {})
        CustomGameEventManager:Send_ServerToAllClients("troll_elves_init_stage_select_perks", {})
        CustomGameEventManager:Send_ServerToAllClients("troll_elves_phase_time", {time = TIMER_STAGE, max_time = TIMER_STAGE_MAX, stage = 3, map = GameRules.MapName, role = true})
        if TIMER_STAGE <= 0 then
            Timers:CreateTimer(1, function()
                SelectHeroes()
                setup_state_lib:SetNextStage()
            end)
            return
        end
        return 1
    end)
end

function setup_state_lib:SetupStartGame1x1()
    Timers:CreateTimer(1, function()
        SelectHeroes()
        setup_state_lib:SetNextStage()
    end)
end

setup_state_lib.CURRENT_QUEUE_STAGE = 1
setup_state_lib.StageQueue = 
{
    setup_state_lib.SetupStartMapVotes,
    setup_state_lib.SetupStartSelectedRole,
    setup_state_lib.SetupStartSelectPerks,
}

if GetMapName() == "1x1" then
    setup_state_lib.StageQueue = 
    {
        setup_state_lib.SetupStartSelectedRole,
        setup_state_lib.SetupStartMapVotes,
        setup_state_lib.SetupStartGame1x1,
    }
end