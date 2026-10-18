if (scr_flag("paintings_solved")) {
    instance_destroy();
    exit;
}

if (steps_left < 0) steps_left = total_seconds * game_get_speed(gamespeed_fps);

if (expired || instance_exists(obj_fade) || instance_exists(obj_dialog_box) || instance_exists(obj_death)) exit;

steps_left--;

if (steps_left <= 0) {
    steps_left = 0;
    expired = true;

    var _d = instance_create_depth(0, 0, -9999, obj_death);
    _d.texto = "Você não foi rápido o suficiente";
    _d.on_retry = function() { scr_change_room(rm_corredor_superior, true); };
}