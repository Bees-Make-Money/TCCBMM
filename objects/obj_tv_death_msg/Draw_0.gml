draw_set_alpha(a);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);

draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_red);
// quebra a linha sozinho; ajuste o 2.2 se ficar grande/pequeno
draw_text_ext_transformed(room_width / 2, room_height / 2, string_copy(msg, 1, floor(idx)),
                          -1, (room_width - 80) / 2.2, 2.2, 2.2, 0);

draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);