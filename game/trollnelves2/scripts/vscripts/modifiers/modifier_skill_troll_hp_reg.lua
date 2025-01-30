LinkLuaModifier("modifier_skill_troll_hp_reg", "modifiers/modifier_skill_troll_hp_reg.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skill_troll_hp_reg_aura", "modifiers/modifier_skill_troll_hp_reg.lua", LUA_MODIFIER_MOTION_NONE)
modifier_skill_troll_hp_reg = class({})


--------------------------------------------------------------------------------

function  modifier_skill_troll_hp_reg:IsHidden()
    return false
end

function  modifier_skill_troll_hp_reg:IsPurgable()
    return false
end

function  modifier_skill_troll_hp_reg:IsStackable()
    return true
end

function  modifier_skill_troll_hp_reg:IsPermanent()
	return false
end

function modifier_skill_troll_hp_reg:GetTexture()
    return "item_hp_reg_12"
end
--------------------------------------------------------------------------------
 modifier_skill_troll_hp_reg_aura = class({})

function  modifier_skill_troll_hp_reg_aura:IsHidden()
    return false
end
function modifier_skill_troll_hp_reg_aura:GetTexture()
    return "item_hp_reg_12"
end
function  modifier_skill_troll_hp_reg_aura:IsPurgable()
    return false
end

function  modifier_skill_troll_hp_reg_aura:IsPermanent()
	return false
end

function modifier_skill_troll_hp_reg_aura:OnCreated( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		DebugPrint("countStack " .. countStack)
		if countStack == 0 then
			countStack = 2
		end
		if target and target.hpReg then
			target.hpReg = target.hpReg + countStack
			CustomGameEventManager:Send_ServerToAllClients("custom_hp_reg", { value=(max(target.hpReg-target.hpRegDebuff,0)),unit=target:GetEntityIndex() })
			target.hpRegLastTime = 2
			DebugPrint("target.hpReg " .. target.hpReg)
		end
	end
end

function modifier_skill_troll_hp_reg_aura:OnRefresh( kv )
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if target and target.hpReg then
			target.hpReg = target.hpReg + countStack - target.hpRegLastTime
			CustomGameEventManager:Send_ServerToAllClients("custom_hp_reg", { value=(max(target.hpReg-target.hpRegDebuff,0)),unit=target:GetEntityIndex() })
			target.hpRegLastTime = countStack
			DebugPrint("target.hpReg " .. target.hpReg)
			DebugPrint("target.hpRegLastTime " .. target.hpRegLastTime)
		end
	end
end

function modifier_skill_troll_hp_reg_aura:OnStackCountChanged()
	if IsServer() then
		local target = self:GetParent()
		local countStack = self:GetStackCount()
		if target and target.hpReg then
			target.hpReg = target.hpReg + countStack - target.hpRegLastTime
			CustomGameEventManager:Send_ServerToAllClients("custom_hp_reg", { value=(max(target.hpReg-target.hpRegDebuff,0)),unit=target:GetEntityIndex() })
			target.hpRegLastTime = countStack
			DebugPrint("target.hpReg " .. target.hpReg)
			DebugPrint("target.hpRegLastTime " .. target.hpRegLastTime)
		end
	end
end

