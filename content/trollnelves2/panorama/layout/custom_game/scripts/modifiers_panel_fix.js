const LocalizeFormat = function () {
	let formatted = $.Localize(arguments[0]);
	for (let i = 1; i < arguments.length; i++) {
		const regex = new RegExp(`%s${i}`, 'g');
		formatted = formatted.replace(regex, arguments[i]);
	}
	return formatted;
};

const GetPlayerColorHex = (playerID) => {
	let color = Players.GetPlayerColor(playerID).toString(16);
	color = color.substring(6, 8) + color.substring(4, 6) + color.substring(2, 4) + color.substring(0, 2);
	return `#${color}`;
};

let rune = 0;
const AlertBehavior_Skip = Symbol("AlertBehavior_Skip");
const ExplicitBehaviors = {

	modifier_ability_test_passive: function (data) {
		// Пример пользовательского поведения
		let [playerid, ent, serial, hasstacks] = [data.playerid, data.ent, data.serial, data.hasstacks];
		return [
			"#Custom_Modifier_Alert",
			[
				// параметры для локализации, при необходимости
			]
		];
	}
};

GameEvents.Subscribe("cdota_buff_alert", function (data) {
	let [playerid, ent, serial, hasstacks] = [data.playerid, data.ent, data.serial, data.hasstacks];
	// Только для своей команды
	if (Players.GetTeam(playerid) != Players.GetTeam(Players.GetLocalPlayer())) return;
	let name = Buffs.GetName(ent, serial);
	if (name === "") return;
	let behavior = ExplicitBehaviors[name];
	if (behavior) {
		let [loc_string, values] = behavior(data);
		$.DispatchEvent("DOTAChatMessagePrintf", LocalizeFormat(loc_string, ...values), playerid, 0);
	} else {
		let playerowner = Entities.GetPlayerOwnerID(ent);
		let iscontrol = Entities.GetPlayerOwnerID(ent) == playerid;
		let isdebuff = Buffs.IsDebuff(ent, serial);
		let remaining_time = Buffs.GetRemainingTime(ent, serial);
		let hasduration = Buffs.GetDuration(ent, serial) > 0 && remaining_time > 0;
		let stackcount = Buffs.GetStackCount(ent, serial);
		let ishero = Entities.IsHero(ent);
		let isenemy = Entities.IsEnemy(ent);

		let loc_string = iscontrol ? "#DOTA_Modifier_Alert" :
			ishero ?
				isenemy ? "#DOTA_Modifier_Alert_Enemy_Hero" : "#DOTA_Modifier_Alert_Ally_Hero" :
				isenemy ? "#DOTA_Modifier_Alert_Enemy_Unit" : "#DOTA_Modifier_Alert_Ally_Unit";

		let s1, s2, s3, s4, s5, s6;
		s1 = isdebuff ? "#ff0000" : "#00ff00";
		// s2 оставляем пустым или используем для префикса стеков если нужно
		s2 = "";

		// Формируем название модификатора + количество стеков (арабские цифры)
		// Показываем число только если стеков > 1 или если флаг hasstacks true
		let showStacks = (stackcount > 1) || hasstacks;
		let stacksText = showStacks ? (" " + stackcount.toString()) : "";
		s3 = $.Localize("#DOTA_Tooltip_" + name) + stacksText;

		switch (loc_string) {
			case "#DOTA_Modifier_Alert":
				s4 = hasduration ? LocalizeFormat("#DOTA_Modifier_Alert_Time_Remaining", remaining_time.toFixed(1)) : "";
				$.DispatchEvent("DOTAChatMessagePrintf", LocalizeFormat(loc_string, s1, s2, s3, s4), playerid, 0);
				break;
			default:
				s4 = GetPlayerColorHex(playerowner);
				s5 = $.Localize(`#${Entities.GetUnitName(ent)}`);
				s6 = hasduration ? LocalizeFormat("#DOTA_Modifier_Alert_Time_Remaining", remaining_time.toFixed(1)) : "";
				$.DispatchEvent("DOTAChatMessagePrintf", LocalizeFormat(loc_string, s1, s2, s3, s4, s5, s6), playerid, 0);
		}
	}
});

let ping_stacks = 2;
let ping_cooldown = 5;
$.RegisterForUnhandledEvent("DOTAShowBuffTooltip", function (buffpanel, ent, serial) {
	let button = buffpanel.GetChild(0);
	let name = Buffs.GetName(ent, serial);
	if (button) {
		button.SetPanelEvent("onactivate", function () {
			if (ExplicitBehaviors[name] == AlertBehavior_Skip) {
				Players.BuffClicked(ent, serial, IsDotaAltPressed());
			} else if (IsDotaAltPressed()) {
				if (ping_stacks <= 0) {
					return;
				}
				ping_stacks--;
				$.Schedule(ping_cooldown, () => {
					ping_stacks++;
				});
				GameEvents.SendCustomGameEventToAllClients("cdota_buff_alert", {
					playerid: Players.GetLocalPlayer(),
					ent: ent,
					serial: serial,
					hasstacks: buffpanel.BHasClass("has_stacks"),
				});
			}
		});
	}
});