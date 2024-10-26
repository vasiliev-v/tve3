modifier_buff_glyph_counter = class({})

function modifier_buff_glyph_counter:IsHidden()
    return false
end

function modifier_buff_glyph_counter:IsDebuff()
    return true
end

function modifier_buff_glyph_counter:GetTexture()
    return "glyph"
end
