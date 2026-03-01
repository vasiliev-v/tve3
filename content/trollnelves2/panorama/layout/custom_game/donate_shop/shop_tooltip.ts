// @ts-nocheck
function UpdateTooltip() {
    const item_name = $.GetContextPanel().GetAttributeString("item_name", "");
    $("#LabelHeader").text = $.Localize("#" + item_name);

    const parent = $.GetContextPanel().GetParent().GetParent();

    const set_color = (name) => {
        parent.FindChildTraverse(name).style.washColor = "rgb(69, 110, 3)";
    };
    set_color("TopArrow");
    set_color("RightArrow");
    set_color("BottomArrow");
    set_color("LeftArrow");
}
