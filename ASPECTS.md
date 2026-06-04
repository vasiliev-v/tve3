# Aspect configuration

The main aspect config is `game/trollnelves2/scripts/vscripts/aspects/aspects_config.lua`.

## Single source of truth

`aspects_config.lua` owns:

- aspect id and icon;
- modifier name;
- shop tooltip localization keys;
- per-level values shown in the UI;
- side (`"0"` = elf, `"1"` = troll);
- enabled flag;
- upgrade price tiers;
- global constants (`MAX_LEVEL`, random aspect cost, base upgrade step cost, upgrade discounts).

`game_spells_lib.lua` loads this file and publishes the same data to Panorama via `CustomNetTables`:

- `game_spells_lib/spell_list` — legacy aspect list used by existing saves and shop data;
- `game_spells_lib/aspects_config` — shared global constants for UI logic;
- `game_spells_lib/spell_cost` — current random aspect cost.

The legacy row format is intentionally preserved to avoid breaking existing player saves/database records:

```lua
{
    "elf_spell_lumber",                  -- [1] id
    "elf_spell_lumber",                  -- [2] icon
    "modifier_elf_spell_lumber",         -- [3] modifier
    {                                    -- [4] tooltip label localization tokens
        "elf_spell_lumber_description_level_1_shop",
        "elf_spell_lumber_description_level_2_shop",
    },
    {                                    -- [5] values by label row and level
        {2, 5, 9},
        {"-20", "-10", "0"},
    },
    "0",                                -- [6] side: elf
    "1",                                -- [7] enabled
    {0, 10000, 30000},                   -- [8] upgrade prices
}
```

## Add a new aspect

1. Add a new row to the correct map branch in `aspects_config:GetLegacySpellList()`.
2. Use a stable unique id in `[1]`; this id is what saves and stats store.
3. Add or reuse an icon under `content/trollnelves2/panorama/images/custom_game/spell_shop/spell_icons/`.
4. Add the Lua modifier/ability logic for the id in `[3]`.
5. Add localization keys used by `[4]` and the base `id_description` text.

## Change balance for an existing aspect

Change the relevant values in `aspects_config.lua` only. For example, to change `elf_spell_lumber` level values, edit the `[5]` table in that aspect row. The shop UI reads the same table through `CustomNetTables`, and server upgrade logic reads the same config module.

## Tooltip templates

Panorama supports simple placeholders in localized text:

```text
"elf_spell_example_description" "Increases damage by {value1}% for {value2} seconds."
```

The UI substitutes `{value1}`, `{value2}` (or `{1}`, `{2}`) from the current level values in `[5]`. This lets descriptions and numeric tables stay synchronized with the config.
