if (fade_in && phase < 3) {
    var _margem = 30;
    var _escala = 1.8;
    var _gh = display_get_gui_height();

    draw_set_font(fnt_testes);
    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_set_alpha(0.7);

    draw_text_transformed(_margem, _gh - _margem, "Clique espaço para pular o texto", _escala, _escala, 0);

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}