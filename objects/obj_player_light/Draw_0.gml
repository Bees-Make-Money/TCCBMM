// Debug: F6 desliga a escuridão para ver o labirinto e as áreas dos lançadores
if (DEBUG_MODE && global.debug_light_off) exit;
if (!instance_exists(obj_player_topview)) exit;

// Centro do sprite do jogador (funciona com qualquer origem)
var _cx = obj_player_topview.x - obj_player_topview.sprite_xoffset + obj_player_topview.sprite_width / 2;
var _cy = obj_player_topview.y - obj_player_topview.sprite_yoffset + obj_player_topview.sprite_height / 2;

draw_sprite_ext(light_sprite, 0, _cx, _cy, light_scale, light_scale, 0, c_white, light_alpha);