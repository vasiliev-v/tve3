luna_lunar_blessing_lua = class({})
LinkLuaModifier( "modifier_venge_range_boost_lua", "lua_abilities/venge_range_boost_lua/modifier_venge_range_boost_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function venge_range_boost_lua:GetIntrinsicModifierName()
	return "modifier_venge_range_boost_lua"
end