var _cx = room_width / 2;
var _cy = room_height / 2;
var _s = room_height / 360;                // escala base da entidade
var _mood = (ending_id == 1) ? 0 : 1;

// Escuridão (cobre a sala inteira)
draw_set_alpha(alpha);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

if (phase == 2) {
    var _k = timer / scare_steps;

    // Flash branco no primeiro instante
    if (timer < 4) {
        draw_set_alpha(0.7);
        draw_set_color(c_white);
        draw_rectangle(0, 0, room_width, room_height, false);
        draw_set_alpha(1);
    }

    // A entidade pisca, treme e vai crescendo
    if (irandom(3) > 0) {
        var _shake = 16 * (1 - _k);
        scr_draw_entity(_cx + random_range(-_shake, _shake), _cy + random_range(-_shake, _shake), _s * (1 + _k * 0.5), _mood, 1);
    }
}

if (phase == 3) {
    // Imagem fantasma ofuscada: várias cópias maiores e translúcidas que somem devagar
    var _g = 1 - timer / ghost_steps;
    for (var i = 0; i < 6; i++) {
        scr_draw_entity(_cx, _cy, _s * (1.5 + i * 0.05), _mood, 0.09 * _g);
    }
}

if (phase >= 4) {
    var _txt = (ending_id == 1) ? "Você conseguiu fugir...." : "Você escolheu se tornar\nparte do hotel.";
    draw_set_font(fnt_testes);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(text_alpha);
    draw_set_color(c_white);
    draw_text_transformed(_cx, _cy, _txt, 1.6, 1.6, 0);
}

// Restaura o estado de desenho
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);