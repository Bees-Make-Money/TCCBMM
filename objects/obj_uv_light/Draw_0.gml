if (!scr_flag("uv_lens_acquired")) exit;
if (!instance_exists(obj_flashlight)) exit;
if (!obj_flashlight.active) exit;
if (instance_exists(obj_inventory_menu)) exit;

var _lx = obj_flashlight.light_x + light_cdx;
var _ly = obj_flashlight.light_y + light_cdy;

// feixe colorido do tamanho da luz original (vale em TODAS as salas)
draw_set_circle_precision(64);
var _layers = 14;
for (var i = 0; i < _layers; i++) {
    draw_set_color(merge_color(uv_edge, uv_core, i / (_layers - 1)));
    draw_set_alpha(0.14);
    draw_circle(_lx, _ly, light_r * (1 - i / _layers), false);
}
draw_set_alpha(1);

// texto oculto: só nas salas que têm texto oculto nascido nelas
var _here = false;
with (obj_hidden_text) {
    if (variable_instance_exists(id, "home_room") && home_room == room) _here = true;
}
if (_here) {
    with (obj_hidden_text) {
        draw_hidden(_lx, _ly, other.light_r, other.uv_text);
    }
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);