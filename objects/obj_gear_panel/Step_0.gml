if (scr_flag("gear_panel_solved") && scr_flag("wiring_fixed")) {
    for (var i = 0; i < array_length(gear_slots); i++) {
        // velocidade inversamente proporcional ao raio (como engrenagens de verdade)
        gear_slots[i].angle += gear_slots[i].dir * (36 / gear_slots[i].r);
    }
}
// quando o puzzle termina, o painel encolhe e some (depois que o diálogo é fechado)
if (scr_flag("negocios_3_unlocked") && !instance_exists(obj_dialog_box)) {
    if (vanish_t == -1) vanish_t = 30;
}
if (vanish_t > 0) {
    vanish_t--;
    if (vanish_t == 0) instance_destroy();
}
// ---------- revelar com a lanterna ----------
if (!panel_revealed) {
    var _rl = variable_instance_exists(id, "panel_left") ? panel_left : bbox_left;
    var _rt = variable_instance_exists(id, "panel_top")  ? panel_top  : bbox_top;

    if (instance_exists(obj_flashlight) && obj_flashlight.active
        && point_in_rectangle(obj_flashlight.light_x, obj_flashlight.light_y, _rl - 30, _rt - 30, _rl + panel_w + 30, _rt + panel_h + 30)) {
        reveal_dwell++;
        if (reveal_dwell >= reveal_frames) {
            panel_revealed = true;
            scr_flag_set("gear_panel_revealed");
            reveal_t = 45;
            scr_show_dialog(["A luz revelou algo na parede: um painel de controle escondido, com uma tampa de madeira."], "Detetive", c_white);
        }
    }
    else {
        reveal_dwell = max(0, reveal_dwell - 1);
    }
}

// tampa abrindo e fechando
var _dt = panel_open ? 1 : 0;
door_t = lerp(door_t, _dt, 0.18);
if (abs(door_t - _dt) < 0.01) door_t = _dt;
if (reveal_t > 0) reveal_t--;
