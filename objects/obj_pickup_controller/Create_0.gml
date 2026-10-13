event_inherited();

item_name = "Controle";
on_pickup = function() {
    scr_flag_set("controller_taken");
}

if (sprite_index == -1) sprite_index = scr_get_simple_placeholder("controller", 56, 36, make_color_rgb(60, 60, 110), "CONTROLE");

sprite_set_offset(sprite_index, sprite_get_width(sprite_index) / 2, sprite_get_height(sprite_index) / 2);

if (scr_flag("controller_taken")) instance_destroy();
