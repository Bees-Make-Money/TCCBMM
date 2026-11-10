if (!global.final_timer_active) {
    instance_destroy();
    exit;
}

// Pausa durante transições, diálogos, o glitch, a tela de morte e as cenas de final.
if (instance_exists(obj_fade) || instance_exists(obj_dialog_box) || instance_exists(obj_death)
    || instance_exists(obj_glitch_effect) || instance_exists(obj_ending_cutscene)) exit;

global.final_timer--;

if (!scr_flag("weird_book_spawned") && global.final_timer <= 15 * fps_game) {
    scr_flag_set("weird_book_spawned");
    if (room == rm_sala_final) scr_spawn_weird_book();
}

if (global.final_timer <= 0) {
    global.final_timer = 0;
    var _d = instance_create_depth(0, 0, -9999, obj_death);
    _d.texto = "O tempo acabou.";
    _d.on_retry = function() {
        scr_final_reset();
        scr_change_room(rm_sala_final, true);
    };
}