function Purge(event)
	local hero = event.caster
	hero:Purge(false,true,false,true,true)
	hero:RemoveModifierByName("modifier_fervor_stack_datadriven") 
	hero:RemoveModifierByName("modifier_clink_swipes2_target_datadriven") 
	hero:RemoveModifierByName("modifier_fury_swipes2_target_datadriven") 
	hero:RemoveModifierByName("modifier_silence") 
	hero:RemoveModifierByName("MODIFIER_STATE_DISARMED") 
	hero:RemoveModifierByName("MODIFIER_STATE_ROOTED") 
	hero:RemoveModifierByName("modifier_fervor_target") 

	DebugPrint("fdsfsdfsdfsd")
end