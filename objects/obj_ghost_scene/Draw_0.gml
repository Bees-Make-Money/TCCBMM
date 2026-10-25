// tremor durante os sustos
if (scare_t > 0) {
    var _sh = scare_fatal ? 8 : 5;
    matrix_set(matrix_world, matrix_build(random_range(-_sh, _sh), random_range(-_sh, _sh), 0, 0, 0, 0, 1, 1, 1));
}

draw_room_art();

// escuridão da sala
draw_set_alpha(ambient_dark);
draw_set_color(make_color_rgb(2, 2, 8));
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// a lanterna clareia o ambiente em volta
if (fl_on) {
    gpu_set_blendmode(bm_add);
    for (var i = 0; i < 6; i++) {
        draw_set_alpha(0.05);
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

    draw_set_alpha(0.92);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);

    if (scare_fatal) {
        draw_set_alpha(0.28);
        draw_set_color(make_color_rgb(160, 10, 10));
        draw_rectangle(0, 0, room_width, room_height, false);
        draw_set_alpha(1);
    }

    var _scale = lerp(3.2, 6.6, min(1, _sp * 5));
    var _jx = random_range(-8, 8);
    var _jy = random_range(-8, 8);
    draw_scare_face(room_width / 2 + _jx, room_height / 2 + _jy, _scale);

    // clarão branco no primeiro instante
    if (_sp < 0.12) {
        draw_set_alpha(1 - _sp / 0.12);
        draw_set_color(c_white);
        draw_rectangle(0, 0, room_width, room_height, false);
        draw_set_alpha(1);
    }
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
