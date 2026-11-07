draw_self();

if (position_meeting(mouse_x, mouse_y, id)) {
    var _label = item_name;
    if (variable_instance_exists(id, "hover_name") && hover_name != "") _label = hover_name;

    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);

    draw_text(x, bbox_top - 5, _label);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}