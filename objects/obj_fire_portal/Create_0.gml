sprite = sprite_index;   // o obj_clickable faz "sprite_index = sprite"
event_inherited();

if (sprite_index == -1) sprite_index = scr_get_simple_placeholder("fire_portal", 56, 56, make_color_rgb(120, 60, 20), "23:46");

pending = false;
portal_lines = ["O relógio parou às 23:46.", "Algo me puxa para dentro dele..."];

custom_click = function() {
    if (scr_flag("fire_solved")) {
        scr_show_dialog(["A memória já me mostrou o que eu precisava."], "Detetive", c_white);
        return;
    }
    global.fire_return_room = room;   // volta para esta sala depois
    scr_show_dialog(portal_lines, "Detetive", c_white);
    pending = true;
}
