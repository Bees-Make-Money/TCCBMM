sprite = sprite_index;   // o obj_clickable faz "sprite_index = sprite"
event_inherited();

// sprite provisório se você ainda não colocou o seu
if (sprite_index == -1) sprite_index = scr_get_simple_placeholder("lens", 40, 40, make_color_rgb(110, 60, 200), "LENTE");
sprite_set_offset(sprite_index, sprite_get_width(sprite_index) / 2, sprite_get_height(sprite_index) / 2);

// já acoplou a lente? então não existe mais
if (scr_flag("uv_lens_acquired")) {
    instance_destroy();
    exit;
}

// NÃO vai para o inventário: é acoplada direto na lanterna
custom_click = function() {
    if (!visible) return;
    scr_flag_set("uv_lens_acquired");
    window_set_cursor(cr_default);
    scr_show_dialog(["Encaixei a lente na lanterna. A luz agora é violeta.",
                     "Com o botão direito do mouse eu ligo a lanterna. Talvez eu consiga enxergar o que está escrito nas paredes."],
                    "Detetive", c_white);
    instance_destroy();
}
