mod_system = class({})
print ( '[[TROLLNELVES2] mod_system' )

mod_system.MODIFIER_ANGELS_WOLVES = 1
mod_system.MODIFIER_ASPECTS = 2

local MOD_LIST =
{
    mod_system.MODIFIER_ANGELS_WOLVES,
    mod_system.MODIFIER_ASPECTS,
}

function mod_system:Init()
    mod_system.votes_map = {}
    mod_system.enabled = {}
    mod_system.voting_finalized = false

    for _, modifier_id in ipairs(MOD_LIST) do
        mod_system.votes_map[modifier_id] = {}
        mod_system.enabled[modifier_id] = true
    end

    GameRules.AngelsEnabled = true
    GameRules.WolvesEnabled = true
    GameRules.AspectsEnabled = true

    CustomGameEventManager:RegisterListener("troll_elves_mod_votes", Dynamic_Wrap(mod_system, "SetVotesMap"))
end

function mod_system:GetEligiblePlayerCount()
    local player_count = tonumber(GameRules.PlayersCount) or 0
    return math.max(player_count, 1)
end

function mod_system:GetVoteCount(modifier_id)
    local votes = mod_system.votes_map[modifier_id] or {}
    local vote_count = 0

    for _ in pairs(votes) do
        vote_count = vote_count + 1
    end

    return vote_count
end

function mod_system:GetDisablePercent(modifier_id)
    return mod_system:GetVoteCount(modifier_id) / mod_system:GetEligiblePlayerCount() * 100
end

function mod_system:BuildVotesPayload()
    local table_votes = {}

    for _, modifier_id in ipairs(MOD_LIST) do
        table.insert(table_votes, {
            map_id = modifier_id,
            votes = mod_system:GetVoteCount(modifier_id),
            percent = mod_system:GetDisablePercent(modifier_id),
        })
    end

    return table_votes
end

function mod_system:SetVotesMap(data)
    if mod_system.voting_finalized or data.PlayerID == nil then
        return
    end

    if not PlayerResource:IsValidPlayerID(data.PlayerID) or PlayerResource:IsFakeClient(data.PlayerID) then
        return
    end

    local modifier_id = tonumber(data.panel_id)
    if mod_system.votes_map[modifier_id] == nil then
        return
    end

    -- A set keyed by PlayerID makes repeated events idempotent while still
    -- allowing the same player to vote once for each independent modifier.
    mod_system.votes_map[modifier_id][data.PlayerID] = true

    CustomGameEventManager:Send_ServerToAllClients(
        "troll_elves_mod_votes_change_visual",
        mod_system:BuildVotesPayload()
    )
end

function mod_system:IsModifierEnabled(modifier_id)
    if mod_system.voting_finalized then
        return mod_system.enabled[modifier_id] ~= false
    end

    return mod_system:GetDisablePercent(modifier_id) < 50
end

function mod_system:AreAspectsEnabled()
    return mod_system:IsModifierEnabled(mod_system.MODIFIER_ASPECTS)
end

function mod_system:AreHelpersEnabled()
    return mod_system:IsModifierEnabled(mod_system.MODIFIER_ANGELS_WOLVES)
end

function mod_system:GetModifierStates()
    return {
        helpers_enabled = mod_system:AreHelpersEnabled(),
        aspects_enabled = mod_system:AreAspectsEnabled(),
    }
end

function mod_system:FinalizeVotes()
    if mod_system.voting_finalized then
        return
    end

    for _, modifier_id in ipairs(MOD_LIST) do
        mod_system.enabled[modifier_id] = mod_system:GetDisablePercent(modifier_id) < 50
    end

    mod_system.voting_finalized = true
    local helpers_enabled = mod_system.enabled[mod_system.MODIFIER_ANGELS_WOLVES]
    GameRules.AngelsEnabled = helpers_enabled
    GameRules.WolvesEnabled = helpers_enabled
    GameRules.AspectsEnabled = mod_system.enabled[mod_system.MODIFIER_ASPECTS]

    CustomGameEventManager:Send_ServerToAllClients(
        "troll_elves_mod_votes_change_visual",
        mod_system:BuildVotesPayload()
    )
end

-- Compatibility for code that still treats Angels and Wolves as one helper
-- modifier. Historically true meant that the combined modifier was disabled.
function mod_system:GetCurrentModFromVotes()
    return not mod_system:AreHelpersEnabled()
end

mod_system:Init()
