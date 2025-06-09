function UpdateTooltip()
{
    let item_name = $.GetContextPanel().GetAttributeString("item_name", "")
    $("#LabelHeader").text = $.Localize("#"+ item_name)

    let parent = $.GetContextPanel().GetParent().GetParent();

    $.Msg("parent", parent)

    let set_color = (name) => {
        parent.FindChildTraverse(name).style.washColor = "rgb(69, 110, 3)";
    };
    set_color("TopArrow");
    set_color("RightArrow");
    set_color("BottomArrow");
    set_color("LeftArrow");
}