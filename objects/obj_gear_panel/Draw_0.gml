event_inherited();

    var _panel_w = 160;
    var _panel_h = 100;
    var _px = x - _panel_w / 2;
    var _py = y - _panel_h / 2;

    draw_set_alpha(0.95);
    draw_set_color(make_color_rgb(40, 32, 20));
    draw_rectangle(_px, _py, _px + _panel_w, _py + _panel_h, false);

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_rectangle(_px, _py, _px + _panel_w, _py + _panel_h, true);

    var _slot_w   = 28;
    var _slot_gap = 14;
    var _total_w  = (gear_slots_total * _slot_w) + ((gear_slots_total - 1) * _slot_gap);
    var _start_x  = x - _total_w / 2;
    var _slot_y   = y;

    for (var i = 0; i < gear_slots_total; i++) {
        var _sx = _start_x + i * (_slot_w + _slot_gap);

        draw_set_alpha(0.6);
        draw_set_color(c_black);
        draw_rectangle(_sx, _slot_y - _slot_w / 2, _sx + _slot_w, _slot_y + _slot_w / 2, false);

        draw_set_alpha(1);
        if (i < gear_slots_filled) {
            draw_set_color(c_yellow);
            draw_rectangle(_sx + 3, _slot_y - _slot_w / 2 + 3, _sx + _slot_w - 3, _slot_y + _slot_w / 2 - 3, false);
        }

        draw_set_color(c_white);
        draw_rectangle(_sx, _slot_y - _slot_w / 2, _sx + _slot_w, _slot_y + _slot_w / 2, true);
    }

    draw_set_halign(fa_center);
    if (panel_solved) {
        draw_set_color(c_lime);
        draw_text(x, _py - 16, "Painel consertado");
    } else {
        draw_set_color(c_white);
        draw_text(x, _py - 16, string(gear_slots_filled) + " / " + string(gear_slots_total) + " engrenagens");
    }
    draw_set_halign(fa_left);
