/// Inicia uma cena de final: 1 = fuga, 2 = dormir.
function scr_start_ending(_id) {
    global.ending_id = _id;
    global.final_timer_active = false;           // a contagem para
    if (_id == 1) scr_flag_set("ending_escape");

    var _c = instance_create_depth(0, 0, -9000, obj_ending_cutscene);
    _c.ending_id = _id;
}

/// Desenha a entidade (versão provisória por código). _mood: 0 = brava, 1 = feliz.
function scr_draw_entity(_cx, _cy, _s, _mood, _a) {
    draw_set_alpha(_a);

    // Halo pálido atrás (para a silhueta aparecer sobre o preto)
    draw_set_color(make_color_rgb(70, 70, 82));
    draw_circle(_cx, _cy - 20 * _s, 150 * _s, false);

    // Manto e capuz (quase pretos)
    draw_set_color(make_color_rgb(6, 6, 8));
    draw_triangle(_cx - 170 * _s, _cy + 180 * _s, _cx + 170 * _s, _cy + 180 * _s, _cx, _cy - 140 * _s, false);
    draw_ellipse(_cx - 95 * _s, _cy - 175 * _s, _cx + 95 * _s, _cy + 35 * _s, false);

    // Contorno claro do capuz
    draw_set_color(make_color_rgb(110, 110, 125));
    draw_ellipse(_cx - 95 * _s, _cy - 175 * _s, _cx + 95 * _s, _cy + 35 * _s, true);

    draw_set_color(c_white);
    if (_mood == 0) {
        // Brava: olhos estreitos e inclinados, boca larga com dentes
        draw_triangle(_cx - 66 * _s, _cy - 100 * _s, _cx - 12 * _s, _cy - 72 * _s, _cx - 66 * _s, _cy - 72 * _s, false);
        draw_triangle(_cx + 66 * _s, _cy - 100 * _s, _cx + 12 * _s, _cy - 72 * _s, _cx + 66 * _s, _cy - 72 * _s, false);
        draw_rectangle(_cx - 60 * _s, _cy - 20 * _s, _cx + 60 * _s, _cy - 8 * _s, false);
        draw_set_color(make_color_rgb(6, 6, 8));
        for (var i = 0; i < 6; i++) {
            var _tx = _cx - 60 * _s + i * 20 * _s;
            draw_triangle(_tx, _cy - 20 * _s, _tx + 20 * _s, _cy - 20 * _s, _tx + 10 * _s, _cy - 8 * _s, false);
        }
    } else {
        // Feliz: olhos redondos e sorriso largo
        draw_circle(_cx - 40 * _s, _cy - 82 * _s, 16 * _s, false);
        draw_circle(_cx + 40 * _s, _cy - 82 * _s, 16 * _s, false);
        var _px = _cx + lengthdir_x(62 * _s, 200);
        var _py = _cy - 30 * _s + lengthdir_y(34 * _s, 200);
        for (var ang = 210; ang <= 340; ang += 10) {
            var _nx = _cx + lengthdir_x(62 * _s, ang);
            var _ny = _cy - 30 * _s + lengthdir_y(34 * _s, ang);
            draw_line_width(_px, _py, _nx, _ny, 5 * _s);
            _px = _nx;
            _py = _ny;
        }
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
}