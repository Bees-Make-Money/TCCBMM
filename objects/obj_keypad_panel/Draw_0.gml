// Escurece a sala
draw_set_alpha(0.75);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// O sprite traz corpo, visor e botões
draw_self();

draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Borda do visor piscando em vermelho quando há erro
if (bad_timer > 0 && (bad_timer div 4) mod 2 == 0) {
    draw_set_color(c_red);
    draw_rectangle(visor_x, visor_y, visor_x + visor_w, visor_y + visor_h, true);
    draw_rectangle(visor_x + 1, visor_y + 1, visor_x + visor_w - 1, visor_y + visor_h - 1, true);
}

// Letras digitadas, com cursor piscando (ou ERRO)
var _shown;
if (bad_timer > 0) _shown = "ERRO";
else _shown = typed + (((current_time div 400) mod 2 == 0) ? "_" : "");
draw_set_color(bad_timer > 0 ? make_color_rgb(150, 20, 20) : make_color_rgb(45, 25, 8));
draw_text_transformed(visor_x + visor_w / 2, visor_y + visor_h / 2, _shown, 2.5, 2.5, 0);

// Destaque do botão sob o mouse (translúcido, sobre a arte)
for (var i = 0; i < 26; i++) {
    var _r = button_rect(i);
    if (point_in_rectangle(mouse_x, mouse_y, _r[0], _r[1], _r[2], _r[3])) {
        draw_set_alpha(0.3);
        draw_set_color(c_white);
        draw_rectangle(_r[0], _r[1], _r[2], _r[3], false);
        draw_set_alpha(1);
        break;
    }
}

// Restaura o estado de desenho
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);