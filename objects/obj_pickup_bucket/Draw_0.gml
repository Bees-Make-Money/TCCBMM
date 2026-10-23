// some enquanto a tela está preta (abertura e fechamento da cena)
if (instance_exists(obj_fire_scene) && obj_fire_scene.black_a > 0.3) exit;

// escurece junto com o salão quando a energia cai
var _d = instance_exists(obj_fire_scene) ? clamp(obj_fire_scene.dark_a / 0.55, 0, 1) : 0;
draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, merge_color(c_white, make_color_rgb(70, 70, 80), _d), 1);
