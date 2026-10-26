if (!tv_is_active()) exit;

var _ox = panel_left;
var _oy = panel_top;
var _w  = tv_w;
var _h  = tv_h;

var _brass    = make_color_rgb(181, 148, 70);
var _brass_dk = make_color_rgb(110, 84, 34);
var _brass_lt = make_color_rgb(232, 206, 130);
var _wood_top = make_color_rgb(92, 46, 28);
var _wood_bot = make_color_rgb(50, 23, 14);

draw_set_alpha(1);

// --- sombra no chão ---
draw_set_alpha(0.35);
draw_set_color(c_black);
draw_ellipse(_ox + 10, _oy + _h - 14, _ox + _w - 10, _oy + _h + 8, false);
draw_set_alpha(1);

// --- pés de madeira com sapatas de latão ---
draw_set_color(_wood_bot);
draw_rectangle(_ox + 24, _oy + _h - 26, _ox + 56, _oy + _h, false);
draw_rectangle(_ox + _w - 56, _oy + _h - 26, _ox + _w - 24, _oy + _h, false);
draw_set_color(_brass_dk);
draw_rectangle(_ox + 24, _oy + _h - 26, _ox + 56, _oy + _h - 22, false);
draw_rectangle(_ox + _w - 56, _oy + _h - 26, _ox + _w - 24, _oy + _h - 22, false);

// --- gabinete de mogno ---
var _cab_h = _h - 24;
draw_rectangle_color(_ox, _oy, _ox + _w, _oy + _cab_h, _wood_top, _wood_top, _wood_bot, _wood_bot, false);

// veios da madeira
draw_set_alpha(0.12);
draw_set_color(c_black);
for (var i = 0; i < 9; i++) {
    draw_line(_ox + 4, _oy + 12 + i * 28, _ox + _w - 4, _oy + 16 + i * 28);
}
draw_set_alpha(1);

// filetes de latão
draw_set_color(_brass);
draw_rectangle(_ox + 5, _oy + 5, _ox + _w - 5, _oy + _cab_h - 5, true);
draw_set_color(_brass_dk);
draw_rectangle(_ox + 7, _oy + 7, _ox + _w - 7, _oy + _cab_h - 7, true);

// --- moldura da tela ---
draw_set_color(make_color_rgb(14, 12, 12));
draw_roundrect_ext(_ox + 18, _oy + 20, _ox + 298, _oy + 234, 14, 14, false);
draw_set_color(_brass_dk);
draw_roundrect_ext(_ox + 18, _oy + 20, _ox + 298, _oy + 234, 14, 14, true);

// --- conteúdo da tela ---
var _sx = _ox + screen_x;
var _sy = _oy + screen_y;
var _sw = screen_w;
var _sh = screen_h;

draw_set_font(fnt_testes);

switch (tv_phase) {

    case "off":
        draw_rectangle_color(_sx, _sy, _sx + _sw, _sy + _sh,
            make_color_rgb(26, 32, 30), make_color_rgb(26, 32, 30),
            make_color_rgb(10, 14, 13), make_color_rgb(10, 14, 13), false);
    break;

    case "bars":
        var _cols = [make_color_rgb(192, 192, 192), make_color_rgb(192, 192, 0), make_color_rgb(0, 192, 192),
                     make_color_rgb(0, 192, 0), make_color_rgb(192, 0, 192), make_color_rgb(192, 0, 0),
                     make_color_rgb(0, 0, 192)];
        var _cols2 = [make_color_rgb(0, 0, 192), c_black, make_color_rgb(192, 0, 192), c_black,
                      make_color_rgb(0, 192, 192), c_black, make_color_rgb(192, 192, 192)];
        var _bw = _sw / 7;

        for (var b = 0; b < 7; b++) {
            draw_set_color(_cols[b]);
            draw_rectangle(_sx + b * _bw, _sy, _sx + (b + 1) * _bw, _sy + _sh * 0.68, false);
            draw_set_color(_cols2[b]);
            draw_rectangle(_sx + b * _bw, _sy + _sh * 0.68, _sx + (b + 1) * _bw, _sy + _sh * 0.80, false);
        }
        draw_set_color(c_black);
        draw_rectangle(_sx, _sy + _sh * 0.80, _sx + _sw, _sy + _sh, false);

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(c_lime);
        draw_text_transformed(_sx + 8, _sy + 6, "AV 1", 0.6, 0.6, 0);

        if (((current_time div 600) mod 2) == 0) {
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_set_color(c_white);
            draw_text_transformed(_sx + _sw / 2, _sy + _sh * 0.90, "SEM SINAL", 0.7, 0.7, 0);
        }
    break;

    case "console":
        draw_rectangle_color(_sx, _sy, _sx + _sw, _sy + _sh,
            make_color_rgb(10, 10, 120), make_color_rgb(10, 10, 120),
            make_color_rgb(0, 0, 50), make_color_rgb(0, 0, 50), false);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text_transformed(_sx + _sw / 2, _sy + _sh * 0.38, "CONSOLE CONECTADO", 0.8, 0.8, 0);
        if (((current_time div 500) mod 2) == 0) {
            draw_set_color(c_yellow);
            draw_text_transformed(_sx + _sw / 2, _sy + _sh * 0.58, "CONECTE O CONTROLE", 0.7, 0.7, 0);
        }
    break;

        case "message":
        draw_set_color(c_black);
        draw_rectangle(_sx, _sy, _sx + _sw, _sy + _sh, false);
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(120, 255, 140));

        // escala que faz a frase INTEIRA caber na tela (nunca corta o fim)
        var _full_w = max(1, string_width(tv_message));
        var _ms     = min(0.9, (_sw - 28) / _full_w);
        var _tx     = _sx + (_sw - _full_w * _ms) / 2;   // sempre começa no mesmo ponto

        // letras já digitadas (o ceil garante que a última letra apareça)
        var _n   = min(string_length(tv_message), ceil(msg_index - 0.001));
        var _txt = string_copy(tv_message, 1, max(0, _n));
        if (((current_time div 400) mod 2) == 0) _txt += "_";
        draw_text_transformed(_tx, _sy + _sh / 2, _txt, _ms, _ms, 0);
		break;

    case "menu":
        draw_rectangle_color(_sx, _sy, _sx + _sw, _sy + _sh,
            make_color_rgb(18, 18, 70), make_color_rgb(18, 18, 70),
            make_color_rgb(6, 6, 30), make_color_rgb(6, 6, 30), false);

        for (var c = 0; c < 3; c++) {
            var _r   = card_rect(c);
            var _hot = (hover_card == c);

            // cartucho
            draw_set_color(_hot ? make_color_rgb(70, 70, 150) : make_color_rgb(34, 34, 90));
            draw_roundrect_ext(_r[0], _r[1], _r[2], _r[3], 8, 8, false);
            draw_set_color(_hot ? c_yellow : make_color_rgb(150, 150, 210));
            draw_roundrect_ext(_r[0], _r[1], _r[2], _r[3], 8, 8, true);

            // etiqueta decorativa
            draw_set_color(make_color_rgb(200, 30, 30));
            draw_rectangle(_r[0] + 8, _r[3] - 22, _r[2] - 8, _r[3] - 12, false);

            var _icx = (_r[0] + _r[2]) / 2;
            var _icy = _r[1] + 44;
            if (c == 0)      draw_icon_football(_icx, _icy, 24);
            else if (c == 1) draw_icon_basketball(_icx, _icy, 24);
            else             draw_icon_car(_icx, _icy, 24);
        }
    break;
}

// --- efeito de tubo: linhas de varredura, brilho e vinheta ---
if (tv_phase != "off") {
    draw_set_alpha(0.12);
    draw_set_color(c_black);
    for (var yy = 0; yy < _sh; yy += 3) {
        draw_line(_sx, _sy + yy, _sx + _sw, _sy + yy);
    }
    draw_set_alpha(random_range(0, 0.04));
    draw_set_color(c_white);
    draw_rectangle(_sx, _sy, _sx + _sw, _sy + _sh, false);
}

draw_set_color(c_black);
for (var k = 0; k < 6; k++) {
    draw_set_alpha(0.18 - k * 0.03);
    draw_rectangle(_sx, _sy + k * 3, _sx + _sw, _sy + k * 3 + 3, false);
    draw_rectangle(_sx, _sy + _sh - k * 3 - 3, _sx + _sw, _sy + _sh - k * 3, false);
    draw_rectangle(_sx + k * 3, _sy, _sx + k * 3 + 3, _sy + _sh, false);
    draw_rectangle(_sx + _sw - k * 3 - 3, _sy, _sx + _sw - k * 3, _sy + _sh, false);
}

// reflexo no vidro
draw_set_alpha(0.08);
draw_set_color(c_white);
draw_triangle(_sx, _sy, _sx + _sw * 0.55, _sy, _sx, _sy + _sh * 0.55, false);
draw_set_alpha(1);

// --- alto-falante ---
draw_set_color(make_color_rgb(40, 28, 16));
draw_rectangle(_ox + 310, _oy + 30, _ox + 362, _oy + 120, false);
draw_set_color(_brass_dk);
draw_rectangle(_ox + 310, _oy + 30, _ox + 362, _oy + 120, true);
draw_set_alpha(0.5);
draw_set_color(_brass);
for (var g = 0; g < 8; g++) {
    draw_line(_ox + 316 + g * 6, _oy + 36, _ox + 316 + g * 6, _oy + 114);
}
draw_set_alpha(1);

// --- botões giratórios de latão ---
for (var kn = 0; kn < 2; kn++) {
    var _kx = _ox + 336;
    var _ky = _oy + 150 + kn * 44;
    draw_circle_color(_kx, _ky, 15, _brass_lt, _brass_dk, false);
    draw_set_color(make_color_rgb(40, 28, 10));
    draw_circle(_kx, _ky, 15, true);
    draw_line_width(_kx, _ky, _kx + lengthdir_x(11, 50 + kn * 70), _ky + lengthdir_y(11, 50 + kn * 70), 2);
}

// --- LED de energia ---
var _pw = scr_flag("tv_on");
draw_set_color(c_black);
draw_circle(_ox + 336, _oy + 222, 6, false);
draw_circle_color(_ox + 336, _oy + 222, 4,
    _pw ? make_color_rgb(150, 255, 160) : make_color_rgb(110, 40, 38),
    _pw ? make_color_rgb(20, 150, 50)   : make_color_rgb(60, 14, 14), false);

// --- plaquinha da marca ---
draw_rectangle_color(_ox + 28, _oy + 246, _ox + 200, _oy + 266, _brass_lt, _brass_lt, _brass, _brass, false);
draw_set_color(_brass_dk);
draw_rectangle(_ox + 28, _oy + 246, _ox + 200, _oy + 266, true);
draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(60, 36, 10));
// se o texto ficar grande/pequeno demais para a sua fonte, ajuste 0.5
draw_text_transformed(_ox + 114, _oy + 256, "ONYX  SUPER COLOR 29", 0.5, 0.5, 0);

// --- botões de latão ---
for (var bt = 0; bt < 5; bt++) {
    draw_set_color(_brass);
    draw_rectangle(_ox + 222 + bt * 28, _oy + 250, _ox + 242 + bt * 28, _oy + 262, false);
    draw_set_color(_brass_dk);
    draw_rectangle(_ox + 222 + bt * 28, _oy + 250, _ox + 242 + bt * 28, _oy + 262, true);
}

// restaura o estado de desenho
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
