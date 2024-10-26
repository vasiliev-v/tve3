--
--
--
--
mirana_star_blessing_lua = class({})
LinkLuaModifier( "modifier_mirana_star_blessing_lua", "lua_abilities/mirana_star_blessing_lua/modifier_mirana_star_blessing_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function mirana_star_blessing_lua:GetIntrinsicModifierName()
	return "modifier_mirana_star_blessing_lua"
end