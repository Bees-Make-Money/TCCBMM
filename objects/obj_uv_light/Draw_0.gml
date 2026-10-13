if (!scr_flag("uv_lens_acquired")) exit;
if (!instance_exists(obj_flashlight)) exit;
if (!obj_flashlight.active) exit;
if (instance_exists(obj_inventory_menu)) exit;

var _lx = obj_flashlight.light_x;
var _ly = obj_flashlight.light_y;
var _r  = min(sprite_get_width(spr_flashlight_light), sprite_get_height(spr_flashlight_light)) / 2 * radius_scale;

// brilho violeta sobre a luz
gpu_set_blendmode(bm_add);
for (var i = 0; i < 6; i++) {
    draw_set_alpha(0.06);
    draw_set_color(make_color_rgb(120, 50, 230));
    draw_circle(_lx, _ly, _r * (1 - i * 0.14), false);
}
gpu_set_blendmode(bm_normal);

// cada texto oculto se desenha só onde a luz passa
with (obj_hidden_text) {
    draw_hidden(_lx, _ly, _r);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
