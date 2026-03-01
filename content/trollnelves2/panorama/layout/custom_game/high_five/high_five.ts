// @ts-nocheck
"use strict";

function HighFiveInit() {
    const high_five_woda = FindDotaHudElement("high_five_woda");
    if (high_five_woda) {
        high_five_woda.DeleteAsync(0);
    }
    const container = GetDotaHud().FindChildTraverse("center_block");
    if (container) {
        const high_five = $.CreatePanel("Button", $.GetContextPanel(), "high_five_woda");
        high_five.BLoadLayoutSnippet("HighFiveSnippet");
        high_five.SetPanelEvent("onactivate", () => HighFive());
        high_five.SetPanelEvent("onmouseover", () => {
            const entindex = Players.GetLocalPlayerPortraitUnit();
            $.DispatchEvent("DOTAShowAbilityTooltipForEntityIndex", high_five, "high_five", entindex);
        });
        high_five.SetPanelEvent("onmouseout", () => $.DispatchEvent("DOTAHideAbilityTooltip", high_five));
        high_five.SetParent(container);
    }
    SetBuffs();
    Tick();
}

function HighFive() {
    const selected_index = Players.GetLocalPlayerPortraitUnit();
    const heroIndex = Game.GetPlayerInfo(Game.GetLocalPlayerID()).player_selected_hero_entity_index;
    if (heroIndex != selected_index) {
        return;
    }
    const ability = Entities.GetAbilityByName(heroIndex, "high_five_custom");
    if (ability) {
        Abilities.ExecuteAbility(ability, heroIndex, false);
    }
}

function Tick() {
    const high_five_woda = FindDotaHudElement("high_five_woda");
    const selected_index = Players.GetLocalPlayerPortraitUnit();
    const heroIndex = Game.GetPlayerInfo(Game.GetLocalPlayerID()).player_selected_hero_entity_index;
    if (high_five_woda) {
        const label = high_five_woda.FindChildTraverse("CooldownLabel");
        const background = high_five_woda.FindChildTraverse("CooldownBackground");
        high_five_woda.SetHasClass("Hidden", !Entities.IsRealHero(selected_index));
        if (heroIndex == selected_index) {
            const ability = Entities.GetAbilityByName(selected_index, "high_five_custom");
            if (ability) {
                const cooldown = Abilities.GetCooldownTimeRemaining(ability);
                const cooldown_ready = Abilities.IsCooldownReady(ability);
                const max_cooldown = Abilities.GetCooldownLength(ability);
                label.text = cooldown_ready ? "" : String(Math.ceil(cooldown));
                background.visible = !cooldown_ready;
                label.visible = !cooldown_ready;
                if (!cooldown_ready) {
                    const progress = (cooldown / max_cooldown) * -360;
                    background.style.clip = `radial(50% 75%, 0deg, ${progress}deg)`;
                }
            }
        } else {
            background.visible = false;
            label.visible = false;
        }
    }
    $.Schedule(0.03, () => Tick());
}

function SetBuffs() {
    const buffs = FindDotaHudElement("buffs");
    if (buffs) {
        buffs.style.marginBottom = "196px";
    }
    const debuffs = FindDotaHudElement("debuffs");
    if (debuffs) {
        debuffs.style.marginBottom = "196px";
    }
}

HighFiveInit();
