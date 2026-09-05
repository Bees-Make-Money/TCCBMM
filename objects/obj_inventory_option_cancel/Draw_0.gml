draw_set_alpha(0.95);
draw_set_color(make_color_rgb(20, 20, 25));
draw_rectangle(x - half_w, y - half_h, x + half_w, y + half_h, false);

draw_set_alpha(1);
draw_set_color(c_white);
draw_rectangle(x - half_w, y - half_h, x + half_w, y + half_h, true);

draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x, y, "Cancelar");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1)