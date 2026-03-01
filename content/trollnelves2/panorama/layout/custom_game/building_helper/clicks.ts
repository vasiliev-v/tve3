// @ts-nocheck
"use strict";

function GetMouseTarget() {
    const mouseEntities = GameUI.FindScreenEntities(GameUI.GetCursorPosition());

    for (var e of mouseEntities) {
        if (!e.accurateCollision) {
            continue;
        }
        return e.entityIndex;
    }

    for (var e of mouseEntities) {
        return e.entityIndex;
    }

    return 0;
}

// Handle Right Button events
function OnRightButtonPressed() {
    EndBuildingHelper();
    const mainSelected = Players.GetLocalPlayerPortraitUnit();
    const pressedShift = GameUI.IsShiftDown();
    const cursor = GameUI.GetCursorPosition();
    const mouseEntities = GameUI.FindScreenEntities(cursor).filter(e => e.entityIndex != mainSelected);
    const right_click_repair = CustomNetTables.GetTableValue("building_settings", "right_click_repair").value;

    // Builder Right Click
    if (IsBuilder(mainSelected) || Entities.GetAbilityByName(mainSelected, "repair")) {
        // Cancel BH
        if (!pressedShift) {
            SendCancelCommand();
        }

        // If it's mousing over entities
        if (mouseEntities.length > 0) {
            for (const e of mouseEntities) {
                const targetIndex = e.entityIndex;
                if (right_click_repair && Clicks_IsCustomBuilding(targetIndex) && Entities.GetHealthPercent(targetIndex) < 100 && IsAlliedUnit(targetIndex, mainSelected)) {
                    GameEvents.SendCustomGameEventToServer("building_helper_repair_command", { targetIndex: targetIndex, queue: pressedShift });
                    return true;
                }
                return false;
            }
        }
    }

    return false;
}

// Handle Left Button events
function OnLeftButtonPressed() {
    return false;
}

function Clicks_IsCustomBuilding(entIndex) {
    return Clicks_HasModifier(entIndex, "modifier_building");
}

function Clicks_HasModifier(entIndex, modifierName) {
    const nBuffs = Entities.GetNumBuffs(entIndex);
    for (let i = 0; i < nBuffs; i++) {
        if (Buffs.GetName(entIndex, Entities.GetBuff(entIndex, i)) == modifierName) {
            return true;
        }
    }
    return false;
}

function IsBuilder(entIndex) {
    const tableValue = CustomNetTables.GetTableValue("builders", entIndex.toString());
    return (tableValue !== undefined) && (tableValue.IsBuilder == 1);
}

function IsAlliedUnit(entIndex, targetIndex) {
    return (Entities.GetTeamNumber(entIndex) == Entities.GetTeamNumber(targetIndex));
}

// Main mouse event callback
GameUI.SetMouseCallback(function (eventName, arg) {
    const CONTINUE_PROCESSING_EVENT = false;
    const LEFT_CLICK = (arg === 0);
    const RIGHT_CLICK = (arg === 1);

    if (GameUI.GetClickBehaviors() !== CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE) {
        return CONTINUE_PROCESSING_EVENT;
    }
    const mainSelected = Players.GetLocalPlayerPortraitUnit();

    if (eventName === "pressed" || eventName === "doublepressed") {
        // //$.Msg("state1 " + state)
        // Builder Clicks
        if (IsBuilder(mainSelected)) {
            // $.Msg("state2 " + state)
            if (LEFT_CLICK) {
                /// /$.Msg("state3 " + state)
                return (state === "active") ? SendBuildCommand() : OnLeftButtonPressed();
            } else if (RIGHT_CLICK) {
                return OnRightButtonPressed();
            }
        }

        if (LEFT_CLICK) {
            return OnLeftButtonPressed();
        } else if (RIGHT_CLICK) {
            return OnRightButtonPressed();
        }
    }

    return CONTINUE_PROCESSING_EVENT;
});
