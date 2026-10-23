event_inherited();

// ---------- tamanho e posição ----------
tv_w = 380;
tv_h = 300;
panel_left = x;   // o ponto da instância é o canto superior esquerdo
panel_top  = y;
was_locked = false;

// ---------- tela (relativo ao canto da TV) ----------
screen_x = 28;
screen_y = 30;
screen_w = 260;
screen_h = 196;

// ---------- cartões dos jogos ----------
card_w   = 72;
card_h   = 100;
card_gap = 16;
card_x0  = screen_x + (screen_w - (3 * card_w + 2 * card_gap)) / 2;
card_y0  = screen_y + (screen_h - card_h) / 2;

// ---------- estado ----------
tv_phase       = "off";   // off, bars, console, message, menu
menu_ready     = false;
tv_message     = "escolha bem o seu jogo";
msg_index      = 0;
msg_hold       = 0;
hover_card     = -1;
prev_hover     = -1;
announce_timer = 0;

// a TV só existe depois de pegar o console E o controle, e some quando o
// jogador vence os pênaltis (a lente toma o lugar dela)
tv_is_active = function() {
    return scr_flag("console_taken") && scr_flag("controller_taken") && !scr_flag("penalty_won");
}
tv_was_active = tv_is_active();

// retângulo de cada cartão (coordenadas da room)
card_rect = function(_i) {
    var _x1 = panel_left + card_x0 + _i * (card_w + card_gap);
    var _y1 = panel_top + card_y0;
    return [_x1, _y1, _x1 + card_w, _y1 + card_h];
}

// ---------- ícones dos jogos ----------
draw_icon_football = function(_cx, _cy, _r) {
    draw_set_color(c_white);
    draw_circle(_cx, _cy, _r, false);
    draw_set_color(c_black);
    draw_circle(_cx, _cy, _r, true);

    // pentágono central
    draw_primitive_begin(pr_trianglefan);
    draw_vertex_color(_cx, _cy, c_black, 1);
    for (var i = 0; i <= 5; i++) {
        var _a = 90 + i * 72;
        draw_vertex_color(_cx + lengthdir_x(_r * 0.38, _a), _cy + lengthdir_y(_r * 0.38, _a), c_black, 1);
    }
    draw_primitive_end();

    // costuras e manchas
    draw_set_color(c_black);
    for (var j = 0; j < 5; j++) {
        var _b = 90 + j * 72;
        draw_line_width(_cx + lengthdir_x(_r * 0.38, _b), _cy + lengthdir_y(_r * 0.38, _b),
                        _cx + lengthdir_x(_r * 0.72, _b), _cy + lengthdir_y(_r * 0.72, _b), 2);
        draw_circle(_cx + lengthdir_x(_r * 0.86, _b + 36), _cy + lengthdir_y(_r * 0.86, _b + 36), _r * 0.16, false);
    }
}

draw_icon_basketball = function(_cx, _cy, _r) {
    draw_set_color(make_color_rgb(228, 110, 30));
    draw_circle(_cx, _cy, _r, false);
    draw_set_color(c_black);
    draw_circle(_cx, _cy, _r, true);
    draw_line_width(_cx - _r, _cy, _cx + _r, _cy, 2);
    draw_line_width(_cx, _cy - _r, _cx, _cy + _r, 2);

    // costuras curvas laterais
    for (var side = -1; side <= 1; side += 2) {
        var _ox = _cx + side * _r * 1.25;
        var _px = 0;
        var _py = 0;
        var _have = false;
        for (var a = -70; a <= 70; a += 10) {
            var _qx = _ox - side * _r * 0.9 * dcos(a);
            var _qy = _cy + _r * 0.9 * dsin(a);
            var _inside = point_distance(_cx, _cy, _qx, _qy) <= _r * 0.98;
            if (_have && _inside) draw_line_width(_px, _py, _qx, _qy, 2);
            _px = _qx;
            _py = _qy;
            _have = _inside;
        }
    }
}

draw_icon_car = function(_cx, _cy, _r) {
    var _s = _r / 26;

    // corpo
    draw_set_color(make_color_rgb(200, 30, 30));
    draw_roundrect_ext(_cx - 26 * _s, _cy - 4 * _s, _cx + 26 * _s, _cy + 12 * _s, 6 * _s, 6 * _s, false);

    // cabine
    draw_triangle(_cx - 16 * _s, _cy - 4 * _s, _cx - 9 * _s, _cy - 15 * _s, _cx + 9 * _s, _cy - 15 * _s, false);
    draw_triangle(_cx - 16 * _s, _cy - 4 * _s, _cx + 9 * _s, _cy - 15 * _s, _cx + 17 * _s, _cy - 4 * _s, false);

    // janelas
    draw_set_color(make_color_rgb(150, 200, 230));
    draw_triangle(_cx - 12 * _s, _cy - 5 * _s, _cx - 7 * _s, _cy - 12 * _s, _cx + 7 * _s, _cy - 12 * _s, false);
    draw_triangle(_cx - 12 * _s, _cy - 5 * _s, _cx + 7 * _s, _cy - 12 * _s, _cx + 13 * _s, _cy - 5 * _s, false);

    // farol
    draw_set_color(make_color_rgb(250, 220, 90));
    draw_rectangle(_cx + 22 * _s, _cy, _cx + 26 * _s, _cy + 4 * _s, false);

    // rodas
    draw_set_color(c_black);
    draw_circle(_cx - 15 * _s, _cy + 12 * _s, 6 * _s, false);
    draw_circle(_cx + 15 * _s, _cy + 12 * _s, 6 * _s, false);
    draw_set_color(make_color_rgb(150, 150, 150));
    draw_circle(_cx - 15 * _s, _cy + 12 * _s, 2.5 * _s, false);
    draw_circle(_cx + 15 * _s, _cy + 12 * _s, 2.5 * _s, false);
}
