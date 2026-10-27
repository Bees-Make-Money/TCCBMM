// Debug: F6 desliga a escuridão para você ver o labirinto e as áreas dos lançadores
if (DEBUG_MODE && global.debug_light_off) exit;
if (!instance_exists(obj_player_topview)) exit;

// Durante a visualização do labirinto a escuridão some, e depois volta aos poucos
var _dark = instance_exists(obj_maze_preview) ? obj_maze_preview.darkness : 1;
if (_dark <= 0) exit;

// Centro do sprite do jogador (funciona com qualquer origem), sem lerp
var _cx = obj_player_topview.x - obj_player_topview.sprite_xoffset + obj_player_topview.sprite_width / 2;
var _cy = obj_player_topview.y - obj_player_topview.sprite_yoffset + obj_player_topview.sprite_height / 2;

draw_sprite_ext(light_sprite, 0, _cx, _cy, light_scale, light_scale, 0, c_white, light_alpha * _dark);