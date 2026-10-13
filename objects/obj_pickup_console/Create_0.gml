event_inherited();

item_name = "Console";
on_pickup = function() {
    scr_flag_set("console_taken");
}

// sprite provisório se você ainda não colocou o seu
if (sprite_index == -1) sprite_index = scr_get_simple_placeholder("console", 64, 40, make_color_rgb(70, 70, 78), "CONSOLE");

// centraliza a origem (o inventário desenha o item pelo centro)
sprite_set_offset(sprite_index, sprite_get_width(sprite_index) / 2, sprite_get_height(sprite_index) / 2);

// já foi pego antes? então não reaparece ao voltar na sala
if (scr_flag("console_taken")) instance_destroy();
