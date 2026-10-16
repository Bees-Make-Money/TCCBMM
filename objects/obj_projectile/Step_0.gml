if (global.interaction_locked) exit;   // congela junto com a tela de morte

x += dir_x * spd;
y += dir_y * spd;

// Acertou o jogador
var _player = instance_place(x, y, obj_player_topview);
if (_player != noone) {
    with (_player) die();
    instance_destroy();
    exit;
}

// Bateu em uma parede ou saiu da sala
if (place_meeting(x, y, obj_maze_wall)
    || x < -64 || x > room_width + 64
    || y < -64 || y > room_height + 64) {
    instance_destroy();
}