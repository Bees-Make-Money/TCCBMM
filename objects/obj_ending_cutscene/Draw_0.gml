var _cx = room_width / 2;
var _cy = room_height / 2;
var _mood = (ending_id == 1) ? 0 : 1;
var _s0 = room_height * 0.9 / 742;           // escala em que o corpo inteiro cabe na sala

// Escuridão (cobre a sala inteira)
draw_set_alpha(alpha);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

if (phase == 2) {
    if (ending_id == 1) {
        // ===== FINAL 1: a entidade brava avança, a boca abre, as mãos vêm para a tela e tudo pisca =====
        var _k = timer / scare_steps;                         // 0 -> 1
        var _e = _k * _k;                                     // aceleração
        var _sc = lerp(_s0, _s0 * 5.2, _e);
        var _ey = lerp(room_height * 0.14, room_height * 0.44, _e);
        var _jaw = clamp((_k - 0.18) / 0.5, 0, 1);
        _jaw = clamp(_jaw + random_range(-0.06, 0.06), 0, 1);
        var _shake = 4 + 24 * _k;

        if ((timer div 2) mod 3 == 0) {
            draw_set_alpha(0.45);
            draw_set_color(make_color_rgb(90, 0, 0));
            draw_rectangle(0, 0, room_width, room_height, false);
            draw_set_alpha(1);
        }

        if (irandom(99) >= 8 + 22 * _k) {
            scr_draw_entity(_cx + random_range(-_shake, _shake), _ey + random_range(-_shake, _shake), _sc, _mood, 1, _k, _jaw);
        }

        if (irandom(99) < 14 + 30 * _k) {
            draw_set_color(choose(c_white, c_white, make_color_rgb(200, 0, 0), c_black));
            draw_set_alpha(random_range(0.25, 0.85));
            draw_rectangle(0, 0, room_width, room_height, false);
        }
        repeat (floor(3 + 10 * _k)) {
            var _by = irandom(room_height);
            draw_set_color(choose(c_white, c_black, make_color_rgb(200, 0, 0)));
            draw_set_alpha(random_range(0.3, 0.9));
            draw_rectangle(0, _by, room_width, _by + irandom_range(2, 26), false);
        }
        draw_set_alpha(1);
    }
    else {
        // ===== FINAL 2: a mesma entidade, agora feliz: aparece devagar, sorri e abre as mãos =====
        var _k2 = timer / scare_steps;                                 // 0 -> 1
        var _a2 = min(clamp(_k2 / 0.25, 0, 1), clamp((1 - _k2) / 0.2, 0, 1));   // fade in (25%) e fade out (20%)
        var _breath = 1 + 0.015 * sin(timer * 0.08);                   // "respira" devagar
        var _sc2 = lerp(_s0 * 1.4, _s0 * 1.8, _k2) * _breath;          // se aproxima devagar
        var _ey2 = lerp(room_height * 0.22, room_height * 0.26, _k2);
        var _reach2 = 0.45 * clamp(_k2 / 0.6, 0, 1);                   // as mãos se abrem para a tela, sem pressa
        scr_draw_entity(_cx, _ey2, _sc2, 1, _a2, _reach2, 0);
    }
}

if (phase == 3 && ending_id == 1) {
    // Imagem fantasma ofuscada (só no final 1)
    var _g = 1 - timer / ghost_steps;
    for (var i = 0; i < 6; i++) {
        scr_draw_entity(_cx, room_height * 0.44, _s0 * 5.2 * (1 + i * 0.03), _mood, 0.08 * _g, 1, 1);
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