function scr_get_simple_placeholder(_key, _w, _h, _color, _label) {
    if (!variable_global_exists("simple_placeholders")) global.simple_placeholders = {};

    if (variable_struct_exists(global.simple_placeholders, _key)) {
        var _cached = global.simple_placeholders[$ _key];
        if (sprite_exists(_cached)) return _cached;
    }

    var _surf = surface_create(_w, _h);
    surface_set_target(_surf);
    draw_clear_alpha(c_black, 0);

    draw_set_color(_color);
    draw_roundrect_ext(0, 0, _w - 1, _h - 1, 8, 8, false);
    draw_set_color(c_white);
    draw_roundrect_ext(0, 0, _w - 1, _h - 1, 8, 8, true);

    draw_set_font(fnt_testes);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_w / 2, _h / 2, _label, 0.4, 0.4, 0);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    surface_reset_target();

    var _spr = sprite_create_from_surface(_surf, 0, 0, _w, _h, false, false, _w / 2, _h / 2);
    surface_free(_surf);

    global.simple_placeholders[$ _key] = _spr;
    return _spr;
}

/// Cria o sprite do papel com o dígito misterioso (ícone do inventário).
function scr_make_paper_sprite(_digit) {
    var _w = 48;
    var _h = 48;

    var _surf = surface_create(_w, _h);
    surface_set_target(_surf);
    draw_clear_alpha(c_black, 0);

    // folha
    draw_set_color(make_color_rgb(235, 225, 190));
    draw_rectangle(8, 4, 40, 44, false);
    draw_set_color(make_color_rgb(150, 130, 90));
    draw_rectangle(8, 4, 40, 44, true);

    // linhas de texto apagadas
    draw_set_color(make_color_rgb(190, 175, 140));
    for (var i = 0; i < 3; i++) {
        draw_line_width(13, 10 + i * 5, 35, 10 + i * 5, 1);
    }

    // dígito
    draw_set_font(fnt_testes);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(150, 20, 20));
    // se o número ficar grande/pequeno demais na sua fonte, ajuste 1.4
    draw_text_transformed(24, 31, string(_digit), 1.4, 1.4, 0);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);

    surface_reset_target();

    var _spr = sprite_create_from_surface(_surf, 0, 0, _w, _h, false, false, _w / 2, _h / 2);
    surface_free(_surf);
    return _spr;
}

/// Desenha uma "cápsula" (linha grossa com pontas arredondadas). Usada nos
/// membros do goleiro e do batedor.
function scr_capsule(_x1, _y1, _x2, _y2, _w, _col) {
    draw_set_color(_col);
    draw_line_width(_x1, _y1, _x2, _y2, _w);
    draw_circle(_x1, _y1, _w / 2, false);
    draw_circle(_x2, _y2, _w / 2, false);
}
