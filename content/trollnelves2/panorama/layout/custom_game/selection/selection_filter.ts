// @ts-nocheck
// Defines scripts to set selection redirects

var DESELECT_BUILDINGS = false; // Get only the units when units&buildings are on the same list
var SELECT_ONLY_BUILDINGS = false; // Get only the buildings when units&buildings are on the same list
var DISPLAY_RANGE_PARTICLE = false; // Uses the main selected entity to update a particle showing attack range
var rangedParticle;

function SelectionFilter(entityList) {
    if (DESELECT_BUILDINGS) {
        if (entityList.length > 1 && IsMixedBuildingSelectionGroup(entityList)) {
            $.Schedule(1 / 60, DeselectBuildings);
        }
    } else if (SELECT_ONLY_BUILDINGS) {
        if (entityList.length > 1 && IsMixedBuildingSelectionGroup(entityList)) {
            $.Schedule(1 / 60, SelectOnlyBuildings);
        }
    }

    if (DISPLAY_RANGE_PARTICLE) {
        const mainSelected = Players.GetLocalPlayerPortraitUnit();

        // Remove old particle
        if (rangedParticle) {
            Particles.DestroyParticleEffect(rangedParticle, true);
        }

        // Create range display on the selected ranged attacker
        if (SelectionFilter_IsCustomBuilding(mainSelected) && Entities.HasAttackCapability(mainSelected)) {
            const range = Entities.GetAttackRange(mainSelected);
            rangedParticle = Particles.CreateParticle("particles/ui_mouseactions/range_display.vpcf", ParticleAttachment_t.PATTACH_CUSTOMORIGIN, mainSelected);
            const position = Entities.GetAbsOrigin(mainSelected);
            position[2] = 380; // Offset
            Particles.SetParticleControl(rangedParticle, 0, position);
            Particles.SetParticleControl(rangedParticle, 1, [range, 0, 0]);
        }
    }

    for (let i = 0; i < entityList.length; i++) {
        const overrideEntityIndex = GetSelectionOverride(entityList[i]);
        if (overrideEntityIndex != -1) {
            GameUI.SelectUnit(overrideEntityIndex, false);
        }
    };
}

function DeselectBuildings() {
    const iPlayerID = Players.GetLocalPlayer();
    const selectedEntities = Players.GetSelectedEntities(iPlayerID);

    skip = true;
    const first = FirstNonBuildingEntityFromSelection(selectedEntities);
    GameUI.SelectUnit(first, false); // Overrides the selection group

    for (const unit of selectedEntities) {
        skip = true; // Makes it skip an update
        if (!SelectionFilter_IsCustomBuilding(unit) && unit != first) {
            GameUI.SelectUnit(unit, true);
        }
    }
}

function FirstNonBuildingEntityFromSelection(entityList) {
    for (let i = 0; i < entityList.length; i++) {
        if (!SelectionFilter_IsCustomBuilding(entityList[i])) {
            return entityList[i];
        }
    }
    return 0;
}

function GetFirstUnitFromSelectionSkipUnit(entityList, entIndex) {
    for (let i = 0; i < entityList.length; i++) {
        if ((entityList[i]) != entIndex) {
            return entityList[i];
        }
    }
    return 0;
}

// Returns whether the selection group contains both buildings and non-building units
function IsMixedBuildingSelectionGroup(entityList) {
    let buildings = 0;
    let nonBuildings = 0;
    for (let i = 0; i < entityList.length; i++) {
        if (SelectionFilter_IsCustomBuilding(entityList[i])) {
            buildings++;
        } else {
            nonBuildings++;
        }
    }
    return (buildings > 0 && nonBuildings > 0);
}

function SelectOnlyBuildings() {
    const iPlayerID = Players.GetLocalPlayer();
    const selectedEntities = Players.GetSelectedEntities(iPlayerID);

    skip = true;
    const first = FirstBuildingEntityFromSelection(selectedEntities);
    GameUI.SelectUnit(first, false); // Overrides the selection group

    for (const unit of selectedEntities) {
        skip = true; // Makes it skip an update
        if (SelectionFilter_IsCustomBuilding(unit) && unit != first) {
            GameUI.SelectUnit(unit, true);
        }
    }
}

function FirstBuildingEntityFromSelection(entityList) {
    for (let i = 0; i < entityList.length; i++) {
        if (SelectionFilter_IsCustomBuilding(entityList[i])) {
            return entityList[i];
        }
    }
    return 0;
}

function SelectionFilter_IsCustomBuilding(entityIndex) {
    return SelectionFilter_HasModifier(entityIndex, "modifier_building");
}

function IsMechanical(entityIndex) {
    const ability_siege = Entities.GetAbilityByName(entityIndex, "ability_siege");
    return (ability_siege != -1);
}

function IsCityCenter(entityIndex) {
    return (Entities.GetUnitLabel(entityIndex) == "city_center");
}

function SelectionFilter_HasModifier(entIndex, modifierName) {
    const nBuffs = Entities.GetNumBuffs(entIndex);
    for (let i = 0; i < nBuffs; i++) {
        if (Buffs.GetName(entIndex, Entities.GetBuff(entIndex, i)) == modifierName) {
            return true;
        }
    };
    return false;
};
