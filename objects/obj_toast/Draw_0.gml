var _a = (timer < hold) ? 1 : 1 - (timer - hold) / fade;

draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_alpha(_a);

draw_set_color(c_black);                                              // sombra
draw_text_transformed(room_width / 2 + 2, 62, text, 1.4, 1.4, 0);
draw_set_color(make_color_rgb(140, 255, 160));                        // texto (verde claro)
draw_text_transformed(room_width / 2, 60, text, 1.4, 1.4, 0);

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);