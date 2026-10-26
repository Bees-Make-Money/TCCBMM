// tremor: forte nos sustos, leve quando um fantasma está perto
var _sh = 0;
if (scare_t > 0) {
    _sh = scare_fatal ? 12 : 7;
}
else if (st == "play" && min_dist < 160) {
    _sh = (1 - min_dist / 160) * 2.5;
}
if (_sh > 0) {
    matrix_set(matrix_world, matrix_build(random_range(-_sh, _sh), random_range(-_sh, _sh), 0, 0, 0, 0, 1, 1, 1));
}

draw_room_art();

// escuridão da sala (falha quando há perigo perto e piora no apagão)
var _dk = ambient_dark;
if (blackout_t > 0) _dk += 0.18;
if (st == "play" && min_dist < 200 && irandom(5) == 0) _dk += 0.12;
draw_set_alpha(min(0.98, _dk));
draw_set_color(make_color_rgb(2, 2, 8));
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// a lanterna clareia o ambiente em volta (e falha quando o perigo está perto)
if (fl_on) {
    var _fk = (st == "play" && min_dist < 200 && irandom(7) == 0) ? 0.4 : 1;
    gpu_set_blendmode(bm_add);
    for (var i = 0; i < 6; i++) {
        draw_set_alpha(0.05 * _fk);
        draw_set_color(make_color_rgb(200, 205, 235));
        draw_circle(lx, ly, light_r * (1 - i * 0.15), false);
    }
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
}

draw_ghosts();

// clarão do banimento
if (flash_t > 0) {
    var _p = 1 - flash_t / 24;
    gpu_set_blendmode(bm_add);
    draw_set_alpha(1 - _p);
    draw_set_color(make_color_rgb(255, 250, 220));
    draw_circle(flash_x, flash_y, 10 + 90 * _p, false);
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
}

// vinheta pulsando com o coração + granulado de filme + estática
if (st == "play" || st == "fail") draw_horror_vignette();

var _sa = 0.05;
if (static_t > 0)   _sa = min(1, 0.30 + 0.5 * static_t / 12);
if (blackout_t > 0) _sa = 0.75;
draw_static(_sa);

// legenda (sussurros e dicas)
if (caption_t > 0 && caption != "") {
    draw_set_font(fnt_testes);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(min(1, caption_t / 30));
    draw_set_color(c_black);
    draw_text_transformed(room_width / 2 + 2, 580, caption, 0.8, 0.8, 0);
    draw_set_color(make_color_rgb(215, 230, 255));
    draw_text_transformed(room_width / 2, 578, caption, 0.8, 0.8, 0);
    draw_set_alpha(1);
}

// ---------- JUMPSCARE ----------
if (scare_t > 0) {
    var _sp = 1 - scare_t / scare_len;

    // fundo preto total
    draw_set_alpha(1);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);

    // o rosto BATE na tela em poucos frames e fica tremendo e mordendo
    var _ease  = min(1, _sp * 7);
    var _scale = lerp(2.2, scare_fatal ? 9.5 : 7.2, _ease * _ease);
    var _jx    = random_range(-14, 14) * (scare_fatal ? 1.4 : 1);
    var _jy    = random_range(-14, 14);
    var _jaw   = 0.55 + 0.45 * sin(anim_t * 1.7);

    if (scare_sprite != -1) {
        // arte própria: cobre a tela inteira, animando
        var _kover = max(room_width / sprite_get_width(scare_sprite), room_height / sprite_get_height(scare_sprite)) * (0.85 + 0.25 * _ease);
        draw_sprite_ext(scare_sprite, (anim_t div 3) mod sprite_get_number(scare_sprite),
                        room_width / 2 + _jx, room_height / 2 + _jy, _kover, _kover, random_range(-1.5, 1.5), c_white, 1);
    }
    else {
        draw_scare_face(room_width / 2 + _jx, room_height / 2 + _jy, _scale, _jaw);
        if (scare_fatal && _ease > 0.5) draw_scare_hands();
    }

    // estrobo vermelho no susto fatal
    if (scare_fatal && ((anim_t div 2) mod 2) == 0) {
        draw_set_alpha(0.32);
        draw_set_color(make_color_rgb(190, 10, 10));
        draw_rectangle(0, 0, room_width, room_height, false);
    }

    // linhas de varredura de TV
    draw_set_alpha(0.18);
    draw_set_color(c_black);
    for (var sy = 0; sy < room_height; sy += 4) {
        draw_line(0, sy, room_width, sy);
    }

    // estática pesada
    draw_static(0.7);

    // últimos frames do fatal: corte seco para estática branca
    if (scare_fatal && scare_t < 14) {
        draw_set_alpha(1 - scare_t / 14);
        draw_set_color(c_white);
        draw_rectangle(0, 0, room_width, room_height, false);
        draw_static(1);
    }

    // clarão branco no primeiro instante
    if (_sp < 0.08) {
        draw_set_alpha(1 - _sp / 0.08);
        draw_set_color(c_white);
        draw_rectangle(0, 0, room_width, room_height, false);
    }
    draw_set_alpha(1);
}

// preto (abertura, falha e fechamento)
if (black_a > 0) {
    draw_set_alpha(black_a);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
}

matrix_set(matrix_world, matrix_build_identity());

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
