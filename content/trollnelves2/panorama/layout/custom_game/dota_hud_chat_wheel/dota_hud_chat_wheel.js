var favourites = new Array();
var nowrings = 8;
var selected_sound_current = undefined;
var nowselect = 0;
var default_button = null

let Items_sounds = 
[
    [801, "sounds_1"],
    [802, "sounds_2"],
    [803, "sounds_3"],
    [804, "sounds_4"],
    [805, "sounds_5"],
    [806, "sounds_6"],
    [807, "sounds_7"],
    [808, "sounds_8"],
    [809, "sounds_9"],
    [810, "sounds_10"],
    [811, "sounds_11"],
    [812, "sounds_12"],
    [813, "sounds_13"],
    [814, "sounds_14"],
    [815, "sounds_15"],
    [816, "sounds_16"],
    [817, "sounds_17"],
    [818, "sounds_18"],
    [819, "sounds_19"],
    [820, "sounds_20"],
    [821, "sounds_21"],
    [822, "sounds_22"],
    [823, "sounds_23"],
    [824, "sounds_24"],
    [825, "sounds_25"],
    [826, "sounds_26"],
    [827, "sounds_27"],
    [828, "sounds_28"],
    [833, "sounds_33"],
    [834, "sounds_34"],
    [836, "sounds_36"],
    [838, "sounds_38"],
    [843, "sounds_43"],
    [844, "sounds_44"],
    [845, "sounds_45"],
    [846, "sounds_46"],
    [847, "sounds_47"],
    [848, "sounds_48"],
    [849, "sounds_49"],
    [850, "sounds_50"],
    [851, "sounds_51"],
    [852, "sounds_52"],
    [853, "sounds_53"],
    [854, "sounds_54"],
    [855, "sounds_55"],
    [856, "sounds_56"],
    [857, "sounds_57"],
    [858, "sounds_58"],
    [859, "sounds_59"],
    [860, "sounds_60"],
    [861, "sounds_61"],
    [862, "sounds_62"],
    [863, "sounds_63"],
    [864, "sounds_64"],
    [865, "sounds_65"],
    [866, "sounds_66"],
    [867, "sounds_67"],
    [868, "sounds_68"],
    [869, "sounds_69"],
    [870, "sounds_70"],
    [871, "sounds_71"],
    [872, "sounds_72"],
    [873, "sounds_73"],
    [874, "sounds_74"],
    [875, "sounds_75"],
    [876, "sounds_76"],
    [877, "sounds_77"],
    [878, "sounds_78"],
    [879, "sounds_79"],
    [880, "sounds_80"],
    [881, "sounds_81"],
    [882, "sounds_82"],
    [883, "sounds_83"],
    [884, "sounds_84"],
    [885, "sounds_85"],
    [886, "sounds_86"],
    [887, "sounds_87"],
    [888, "sounds_88"],
    [889, "sounds_89"],
    [890, "sounds_90"],
    [891, "sounds_91"],
    [892, "sounds_92"],
    [893, "sounds_93"],
    [894, "sounds_94"],
    [895, "sounds_95"],
    [896, "sounds_96"],
    [897, "sounds_97"],

    
]
var player_table = CustomNetTables.GetTableValue("Shop", Players.GetLocalPlayer());
var player_items = player_table && player_table[1] ? player_table[1] : {};

var itemTypes = [Items_sounds];
var rings = [
    [
        [],
        [],
        [],
    ],
];

for (var itemType_find of itemTypes) 
{
    for (var item_find of itemType_find)
    {
        if (!player_items[String(item_find[0])])
        {
            continue;
        }

        let current_ring = rings[rings.length - 1];
        if (current_ring[0].length < 8)
        {
            current_ring[0].push($.Localize("#" + item_find[1]));
            current_ring[1].push(true);
            current_ring[2].push(Number(item_find[0]));
        }
        else
        {
            rings.push([[$.Localize("#" + item_find[1])], [true], [Number(item_find[0])]]);
        }
    }
}

if (rings[rings.length - 1][0].length < 8)
{
    for ( var i = rings[rings.length - 1][0].length; i < 8; i++ )
    {
        rings[rings.length - 1][0].push("")
        rings[rings.length - 1][1].push(false)
        rings[rings.length - 1][2].push(0)
    }
}

function StartWheel() 
{
    selected_sound_current = undefined;
    $("#Wheel").visible = true;
    $("#Bubble").visible = true;
    $("#PhrasesContainer").visible = true;
    $("#ChangeWheelButtons").visible = true;
    $("#ChangeWheelButtonLabel").text = (nowselect + 1) + " / " + rings.length 
    $("#PhrasesContainer").RemoveAndDeleteChildren();

    for ( var i = 0; i < 8; i++ )
    {
        $.CreatePanel(`Button`, $("#PhrasesContainer"), `Phrase${i}`, {
            class: `MyPhrases`,
            onmouseover: `OnMouseOver(${i})`,
            onmouseout: `OnMouseOut(${i})`,
        });
        $("#Phrase"+i).BLoadLayoutSnippet("Phrase");
        $("#Phrase"+i).GetChild(0).GetChild(0).visible = rings[0][1][i];
        var phase_deactive = false

        
        if (rings[nowselect][1][i] == false)
            {
            $("#Phrase"+i).style.visibility = "collapse"
        } else {
            $("#Phrase"+i).style.visibility = "visible"
        }

        $("#Phrase"+i).GetChild(0).GetChild(0).text = $.Localize(rings[nowselect][0][i]);

        if (phase_deactive) {   
            var blocked = $.CreatePanel("Panel", $("#Phrase"+i).GetChild(0), "" );
            blocked.AddClass("BlockChatWheel");
            $("#Phrase"+i).GetChild(0).style.washColor = "red"
        }
    }
}

function LeftButton()
{
    if (nowselect - 1 < 0)
    {
        nowselect = rings.length - 1
    } else {
        nowselect = nowselect - 1
    }
    $("#ChangeWheelButtonLabel").text = (nowselect + 1) + " / " + rings.length
    $("#PhrasesContainer").RemoveAndDeleteChildren();
    for ( var i = 0; i < 8; i++ )
    {
        let properities_for_panel = {
            class: `MyPhrases`,
            onmouseover: `OnMouseOver(${i})`,
            onmouseout: `OnMouseOut(${i})`,
        };

        $.CreatePanel(`Button`, $("#PhrasesContainer"), `Phrase${i}`, properities_for_panel);
        $("#Phrase"+i).BLoadLayoutSnippet("Phrase");
        var phase_deactive = false


            if (rings[nowselect][1][i] == false)
            {
            $("#Phrase"+i).style.visibility = "collapse"
            } else {
            $("#Phrase"+i).style.visibility = "visible"
            }

        $("#Phrase"+i).GetChild(0).GetChild(0).text = $.Localize(rings[nowselect][0][i]);

        if (phase_deactive) {   
            var blocked = $.CreatePanel("Panel", $("#Phrase"+i).GetChild(0), "" );
            blocked.AddClass("BlockChatWheel");
            $("#Phrase"+i).GetChild(0).style.washColor = "red"
        }
    }
}

function RightButton()
{
    if (nowselect + 1 > (rings.length - 1))
    {
        nowselect = 0
    } else {
        nowselect = nowselect + 1
    }
    $("#ChangeWheelButtonLabel").text = (nowselect + 1) + " / " + rings.length
    $("#PhrasesContainer").RemoveAndDeleteChildren();
    for ( var i = 0; i < 8; i++ )
    {
        let properities_for_panel = {
            class: `MyPhrases`,
            onmouseover: `OnMouseOver(${i})`,
            onmouseout: `OnMouseOut(${i})`,
        };

        $.CreatePanel(`Button`, $("#PhrasesContainer"), `Phrase${i}`, properities_for_panel);
        $("#Phrase"+i).BLoadLayoutSnippet("Phrase");
        var phase_deactive = false


            if (rings[nowselect][1][i] == false)
            {
            $("#Phrase"+i).style.visibility = "collapse"
            } else {
            $("#Phrase"+i).style.visibility = "visible"
            }

        $("#Phrase"+i).GetChild(0).GetChild(0).text = $.Localize(rings[nowselect][0][i]);

        if (phase_deactive) {   
            var blocked = $.CreatePanel("Panel", $("#Phrase"+i).GetChild(0), "" );
            blocked.AddClass("BlockChatWheel");
            $("#Phrase"+i).GetChild(0).style.washColor = "red"
        }
    }
}

function StopWheel() {
    $("#Wheel").visible = false;
    $("#Bubble").visible = false;
    $("#PhrasesContainer").visible = false;
    $("#ChangeWheelButtons").visible = false;
    var newnum = rings[nowselect][2][selected_sound_current];
    if (rings[nowselect][1][selected_sound_current])
    {
        GameEvents.SendCustomGameEventToServer("SelectVO", {num: Number(newnum)});
    }
    selected_sound_current = undefined;
}

function OnMouseOver(num) {
    selected_sound_current = num;
    $( "#WheelPointer" ).RemoveClass( "Hidden" );
    $( "#Arrow" ).RemoveClass( "Hidden" );
    for ( var i = 0; i < 8; i++ )
    {
        if ($("#Wheel").BHasClass("ForWheel"+i))
            $( "#Wheel" ).RemoveClass( "ForWheel"+i );
    }
    $( "#Wheel" ).AddClass( "ForWheel"+num );
}

function OnMouseOut(num) {
    selected_sound_current = undefined;
    $( "#WheelPointer" ).AddClass( "Hidden" );
    $( "#Arrow" ).AddClass( "Hidden" );
}

const english_language_button = 
{
    "q" : "й",
    "w" : "ц",
    "e" : "у",
    "r" : "к",
    "t" : "е",
    "y" : "н",
    "u" : "г",
    "i" : "ш",
    "o" : "щ",
    "p" : "з",
    "a" : "ф",
    "s" : "ы",
    "d" : "в",
    "f" : "а",
    "g" : "п",
    "h" : "р",
    "j" : "о",
    "k" : "л",
    "l" : "д",
    "z" : "я",
    "x" : "ч",
    "c" : "с",
    "v" : "м",
    "b" : "и",
    "n" : "т",
    "m" : "ь",
}

const russian_language_button = 
{
    "й" : "q",
    "ц" : "w",
    "у" : "e",
    "к" : "r",
    "е" : "t",
    "н" : "y",
    "г" : "u",
    "ш" : "i",
    "щ" : "o",
    "з" : "p",
    "ф" : "a",
    "ы" : "s",
    "в" : "d",
    "а" : "f",
    "п" : "g",
    "р" : "h",
    "о" : "j",
    "л" : "k",
    "д" : "l",
    "я" : "z",
    "ч" : "x",
    "с" : "c",
    "м" : "v",
    "и" : "b",
    "т" : "n",
    "ь" : "m",
}
 
function SetKeyBindChatWheel()
{
    let original_keybind = "L".toLowerCase()
    if (default_button != original_keybind ) 
    {
        if (original_keybind == "")
        {
            original_keybind = "L"
        }
        original_keybind = original_keybind.toLowerCase()
        if (russian_language_button[original_keybind])
        {
            original_keybind = russian_language_button[original_keybind]
        }
        CreateKeyBind(original_keybind)
        if (english_language_button[original_keybind])
        {
            CreateKeyBind(english_language_button[original_keybind])  
        }
        default_button = original_keybind
        GameUI.CustomUIConfig().button_with_wheel = original_keybind.toUpperCase()
    } 
    $.Schedule( 1, SetKeyBindChatWheel );
}

function CreateKeyBind(key_name)
{
    const name_bind = "WheelButton" + Math.floor(Math.random() * 99999999);
    Game.AddCommand("+" + name_bind, StartWheel, "", 0);
    Game.AddCommand("-" + name_bind, StopWheel, "", 0);
    Game.CreateCustomKeyBind(key_name, "+" + name_bind);
} 

function GetGameKeybind(command) 
{
    return Game.GetKeybindForCommand(command);
}

(function() {
	GameUI.CustomUIConfig().chatWheelLoaded = true;
    SetKeyBindChatWheel()
    $("#Wheel").visible = false;
    $("#Bubble").visible = false;
    $("#PhrasesContainer").visible = false;
    $("#ChangeWheelButtons").visible = false;
})();