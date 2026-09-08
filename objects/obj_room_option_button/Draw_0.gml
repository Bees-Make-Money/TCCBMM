draw_set_alpha(1);
draw_set_font(fnt_testes);
draw_set_color(c_white);
draw_set_valign(fa_middle);

if (is_back_btn) {
    draw_set_halign(fa_left);
} else {
    draw_set_halign(fa_center);
}

draw_text(x, y, room_label);

draw_set_halign(fa_left);
draw_set_valign(fa_top);