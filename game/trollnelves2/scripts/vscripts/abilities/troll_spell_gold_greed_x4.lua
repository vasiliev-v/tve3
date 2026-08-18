troll_spell_gold_greed_x4 = class({})

function troll_spell_gold_greed_x4:OnSpellStart()
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end

	local bankMod = caster:FindModifierByName("modifier_troll_spell_gold_greed_bank")
	local bankGold = (bankMod and not bankMod:IsNull()) and bankMod:GetStackCount() or 0

	local multPercent = self:GetSpecialValueFor("gold_multiplier")
	if multPercent == 0 then
		local lvl = self:GetLevel()
		if lvl == 1 then multPercent = 250
		elseif lvl == 2 then multPercent = 350
		elseif lvl >= 3 then multPercent = 450
		else multPercent = 250 end
	end

	-- payout = accumulated gold * multiplier (250% / 350% / 450%)
	local multiplier = multPercent / 100.0
	local payout = math.floor(bankGold * multiplier)

	if payout > 0 then
		local playerID = caster:GetPlayerOwnerID()
		local currentGold = PlayerResource:GetGold(playerID)
		local totalGold = currentGold + payout
		-- 64,000 gold = 1 lumber conversion
		local totalLumberToAdd = math.floor(totalGold / 64000)
		local leftoverGold = totalGold % 64000

		if totalLumberToAdd > 0 then
			PlayerResource:ModifyLumber(caster, totalLumberToAdd, true)
			PopupLumber(caster, totalLumberToAdd, true)
		end

		PlayerResource:SetGold(caster, leftoverGold)
		PopupGoldGain(caster, payout)
	end

	caster:EmitSound("General.Coins")

	if bankMod and not bankMod:IsNull() then
		caster:RemoveModifierByName("modifier_troll_spell_gold_greed_bank")
	end

	caster.greed_activated = true
	self:StartCooldown(999999)
end
