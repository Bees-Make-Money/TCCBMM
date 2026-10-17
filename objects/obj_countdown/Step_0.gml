if (steps_left < 0) steps_left = total_seconds * game_get_speed(gamespeed_fps);

// Para quando a tela de morte, um diálogo ou a saída do labirinto estiverem ativos
if (global.interaction_locked || expired) exit;
if (instance_exists(obj_player_topview)
    && (obj_player_topview.dead || obj_player_topview.entering_portal)) exit;

steps_left--;

if (steps_left <= 0) {
    steps_left = 0;
    expired = true;
    with (obj_player_topview) die("O tempo acabou.");
}