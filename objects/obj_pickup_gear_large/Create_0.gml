event_inherited();

item_name = "Engrenagem Grande";
on_pickup = function() {
    scr_flag_set("gear_large_taken");
}

// sprite provisório se o objeto ainda não tem sprite
if (sprite_index == -1) sprite_index = scr_get_placeholder_sprite("gear_large");

// centraliza a origem (o inventário desenha o item pelo centro)
sprite_set_offset(sprite_index, sprite_get_width(sprite_index) / 2, sprite_get_height(sprite_index) / 2);

scr_place_pickup("gear_large");

if (scr_flag("gear_large_taken")) instance_destroy();
