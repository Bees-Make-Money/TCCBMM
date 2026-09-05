draw_self();

draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);

if (back_option != noone) {
    draw_text(x, back_title_y, "Voltar para");
}

draw_text(x, forward_title_y, "Ir para");

draw_set_halign(fa_left);
draw_set_valign(fa_top);