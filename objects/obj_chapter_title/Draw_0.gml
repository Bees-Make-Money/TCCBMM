var _k = min(display_get_gui_width() / room_width, display_get_gui_height() / room_height);
var _scale = title_size / _k;

draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_alpha(alpha);

draw_set_color(c_black);                                                  // sombra
draw_text_transformed(room_width / 2 + 2, title_y + 2, text, _scale, _scale, 0);
draw_set_color(c_white);                                                  // texto
draw_text_transformed(room_width / 2, title_y, text, _scale, _scale, 0);

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);