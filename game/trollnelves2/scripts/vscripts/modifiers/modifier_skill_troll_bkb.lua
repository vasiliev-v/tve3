LinkLuaModifier("modifier_skill_troll_bkb", "modifiers/modifier_skill_troll_bkb.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_troll_bkb_aura", "modifiers/modifier_skill_troll_bkb.lua", LUA_MODIFIER_MOTION_NONE)
modifier_skill_troll_bkb = class({})

--------------------------------------------------------------------------------

function  modifier_skill_troll_bkb:IsHidden()
    return false
end

function  modifier_skill_troll_bkb:IsPurgable()
    return false
end

function  modifier_skill_troll_bkb:IsStackable()
    return true
end

function  modifier_skill_troll_bkb:IsPermanent()
	return false
end

function modifier_skill_troll_bkb:GetTexture()
    return "lia_totem_of_persistence"
end
-------------------------------------------------------------------------------- 
 modifier_skill_troll_bkb_aura = class({})
 function modifier_skill_troll_bkb_aura:CheckState()
	local state =
	{
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
	return state
end
function  modifier_skill_troll_bkb_aura:IsHidden()
    return false
end
function modifier_skill_troll_bkb_aura:GetTexture()
    return "lia_totem_of_persistence"
end

function  modifier_skill_troll_bkb_aura:IsPurgable()
    return false
end

function  modifier_skill_troll_bkb_aura:IsPermanent()
	return false
end

function modifier_skill_troll_bkb_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if countStack == 0 then
			countStack = 1
		end
		self:SetStackCount(countStack)
		self.particle1 = ParticleManager:Create('particles/items_fx/black_king_bar_avatar.vpcf', PATTACH_ABSORIGIN_FOLLOW, target)
		self:SetDuration(30, true)
	end
end

function modifier_skill_troll_bkb_aura:OnRefresh( kv )
	if IsServer() then
		local caster = self:GetCaster()
		local target = self:GetParent()
		local countStack = caster:FindModifierByName("modifier_skill_troll_bkb_aura"):GetStackCount()
		self:SetStackCount(countStack)
	end
end

function modifier_skill_troll_bkb_aura:OnDestroy()
	if IsServer() then
		ParticleManager:Fade(self.particle1, true)
	end
end

