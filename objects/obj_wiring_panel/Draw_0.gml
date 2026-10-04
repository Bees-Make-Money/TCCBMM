event_inherited();

    var _panel_w = 160;
    var _panel_h = 100;
    var _px = x - _panel_w / 2;
    var _py = y - _panel_h / 2;

    draw_set_alpha(0.95);
    draw_set_color(make_color_rgb(25, 25, 30));
    draw_rectangle(_px, _py, _px + _panel_w, _py + _panel_h, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_rectangle(_px, _py, _px + _panel_w, _py + _panel_h, true);

    var _wire_gap = _panel_h / (wire_count + 1);

    for (var i = 0; i < wire_count; i++) {
        var _wy = _py + _wire_gap * (i + 1);

        if (wires_fixed[i]) {
            // fio consertado: linha reta e verde
            draw_set_color(c_lime);
            draw_line_width(_px + 10, _wy, _px + _panel_w - 10, _wy, 3);
        } else {
            // fio em curto: zigue-zague vermelho
            draw_set_color(c_red);
            var _seg   = 6;
            var _steps = (_panel_w - 20) / _seg;
            for (var s = 0; s < _steps; s++) {
                var _sx0 = _px + 10 + s * _seg;
                var _sy0 = _wy + ((s mod 2 == 0) ? -4 : 4);
                var _sx1 = _px + 10 + (s + 1) * _seg;
                var _sy1 = _wy + (((s + 1) mod 2 == 0) ? -4 : 4);
                draw_line_width(_sx0, _sy0, _sx1, _sy1, 3);
            }
        }
    }

    draw_set_halign(fa_center);
    if (panel_solved) {
        draw_set_color(c_lime);
        draw_text(x, _py - 16, "Fiação normalizada");
    } else {
        var _n_fixed = 0;
        for (var i = 0; i < wire_count; i++) if (wires_fixed[i]) _n_fixed++;
        draw_set_color(c_white);
        draw_text(x, _py - 16, string(_n_fixed) + " / " + string(wire_count) + " fios consertados");
    }
    draw_set_halign(fa_left);
