if (!panel_revealed) exit;   // invisível até a lanterna passar
if (vanish_t > 0) {
    var _vs  = vanish_t / 30;
    var _vl  = variable_instance_exists(id, "panel_left") ? panel_left : bbox_left;
    var _vt  = variable_instance_exists(id, "panel_top")  ? panel_top  : bbox_top;
    var _vcx = _vl + panel_w / 2;
    var _vcy = _vt + panel_h / 2;
    matrix_set(matrix_world, matrix_build(_vcx * (1 - _vs), _vcy * (1 - _vs), 0, 0, 0, 0, _vs, _vs, 1));
}
var _px = bbox_left;
var _py = bbox_top;
var _w  = panel_w;
var _h  = panel_h;

var _brass    = make_color_rgb(181, 148, 70);
var _brass_dk = make_color_rgb(110, 84, 34);
var _brass_lt = make_color_rgb(232, 206, 130);
var _wood_top = make_color_rgb(76, 38, 24);
var _wood_bot = make_color_rgb(42, 19, 12);

draw_set_alpha(1);

// --- sombra ---
draw_set_alpha(0.35);
draw_set_color(c_black);
draw_rectangle(_px + 6, _py + 6, _px + _w + 6, _py + _h + 6, false);
draw_set_alpha(1);

// --- moldura de mogno ---
draw_rectangle_color(_px, _py, _px + _w, _py + _h, _wood_top, _wood_top, _wood_bot, _wood_bot, false);

// --- filetes de latão ---
draw_set_color(_brass);
draw_rectangle(_px + 5, _py + 5, _px + _w - 5, _py + _h - 5, true);
draw_set_color(_brass_dk);
draw_rectangle(_px + 7, _py + 7, _px + _w - 7, _py + _h - 7, true);

// --- rebites ---
draw_circle_color(_px + 14,      _py + 14,      3, _brass_lt, _brass_dk, false);
draw_circle_color(_px + _w - 14, _py + 14,      3, _brass_lt, _brass_dk, false);
draw_circle_color(_px + 14,      _py + _h - 14, 3, _brass_lt, _brass_dk, false);
draw_circle_color(_px + _w - 14, _py + _h - 14, 3, _brass_lt, _brass_dk, false);

// --- plaquinha de latão ---
draw_rectangle_color(_px + _w/2 - 90, _py + 12, _px + _w/2 + 90, _py + 40, _brass_lt, _brass_lt, _brass, _brass, false);
draw_set_color(_brass_dk);
draw_rectangle(_px + _w/2 - 90, _py + 12, _px + _w/2 + 90, _py + 40, true);

draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(60, 36, 10));
// se o texto ficar grande/pequeno demais para a sua fonte, ajuste 0.6
draw_text_transformed(_px + _w/2, _py + 26, "ACESSO RESTRITO", 0.6, 0.6, 0);

// --- LEDs: engrenagens, fiação e porta ---
draw_led(_px + 40,      _py + 26, scr_flag("gear_panel_solved"));
draw_led(_px + 66,      _py + 26, scr_flag("wiring_fixed"));
draw_led(_px + _w - 40, _py + 26, scr_flag("negocios_3_unlocked"));

// ==================== JANELA DO MECANISMO ====================
draw_recess(_px + 16, _py + 48, _px + 216, _py + 272, make_color_rgb(14, 40, 32), make_color_rgb(8, 22, 18));

draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(_brass_lt);
draw_text_transformed(_px + 80, _py + 62, "MECANISMO", 0.5, 0.5, 0);

for (var i = 0; i < array_length(gear_slots); i++) {
    var _s  = gear_slots[i];
    var _cx = _px + _s.lx;
    var _cy = _py + _s.ly;

    if (scr_flag(_s.flag)) {
        // engrenagem encaixada (gira quando o painel está energizado)
        scr_draw_gear(_s.spr, _cx, _cy, _s.r * 2, _s.angle, c_white, 1);
    }
    else {
        // silhueta fantasma: mostra o tamanho que falta aqui
        scr_draw_gear(_s.spr, _cx, _cy, _s.r * 2, 0, _brass_dk, 0.35);
        draw_set_alpha(0.6);
        draw_set_color(_brass_dk);
        draw_circle(_cx, _cy, _s.r + 2, true);
        draw_set_alpha(1);
    }

    // pino do eixo
    draw_circle_color(_cx, _cy, 5, _brass_lt, _brass_dk, false);
}

// ==================== BLOCO DE FIAÇÃO ====================
draw_recess(_px + 232, _py + 48, _px + 416, _py + 272, make_color_rgb(26, 26, 30), make_color_rgb(10, 10, 12));

draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(_brass_lt);
draw_text_transformed(_px + 324, _py + 62, "FIAÇÃO", 0.5, 0.5, 0);

// réguas de terminais
draw_set_color(make_color_rgb(60, 60, 66));
draw_rectangle(_px + 236, _py + 80, _px + 254, _py + 244, false);
draw_rectangle(_px + 394, _py + 80, _px + 412, _py + 244, false);

var _fixed = scr_flag("wiring_fixed");

for (var w = 0; w < array_length(wires); w++) {
    var _wr  = wires[w];
    var _p   = _wr.pts;
    var _cut = (_wr.shorted && _fixed);

    // contorno preto
    for (var s = 0; s < array_length(_p) - 1; s++) {
        if (_cut && (s == 7 || s == 8)) continue; // vão do corte
        draw_line_width_color(_px + _p[s][0], _py + _p[s][1], _px + _p[s + 1][0], _py + _p[s + 1][1], 6, c_black, c_black);
    }
    // cor do fio
    for (var s = 0; s < array_length(_p) - 1; s++) {
        if (_cut && (s == 7 || s == 8)) continue;
        draw_line_width_color(_px + _p[s][0], _py + _p[s][1], _px + _p[s + 1][0], _py + _p[s + 1][1], 3, _wr.col, _wr.col);
    }

    // pontas de cobre expostas do fio cortado
    if (_cut) {
        draw_circle_color(_px + _p[7][0], _py + _p[7][1], 3, make_color_rgb(230, 140, 80), make_color_rgb(150, 80, 40), false);
        draw_circle_color(_px + _p[9][0], _py + _p[9][1], 3, make_color_rgb(230, 140, 80), make_color_rgb(150, 80, 40), false);
    }

    // parafusos dos terminais
    draw_circle_color(_px + 244, _py + _wr.base_y, 6, _brass_lt, _brass_dk, false);
    draw_circle_color(_px + 404, _py + _wr.base_y, 6, _brass_lt, _brass_dk, false);
    draw_set_color(_brass_dk);
    draw_line_width(_px + 241, _py + _wr.base_y - 2, _px + 247, _py + _wr.base_y + 2, 2);
    draw_line_width(_px + 401, _py + _wr.base_y - 2, _px + 407, _py + _wr.base_y + 2, 2);
}

// faíscas no ponto do curto (somem quando o fio é cortado)
if (!_fixed) {
    var _sx = _px + wires[1].pts[8][0];
    var _sy = _py + (wires[1].pts[8][1] + wires[2].pts[8][1]) / 2;

    // marca de queimado
    draw_set_alpha(0.5);
    draw_set_color(make_color_rgb(30, 18, 10));
    draw_circle(_sx, _sy, 9, false);
    draw_set_alpha(1);

    // faíscas piscando
    if (irandom(3) != 0) {
        repeat (5) {
            var _a = random(360);
            draw_line_width_color(_sx, _sy,
                                  _sx + lengthdir_x(random_range(4, 12), _a),
                                  _sy + lengthdir_y(random_range(4, 12), _a),
                                  1, c_yellow, c_white);
        }
        draw_circle_color(_sx, _sy, 3, c_white, c_yellow, false);
    }
}

// restaura o estado de desenho
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
// ---------- tampa de madeira que fecha o mecanismo ----------
var _cvx1 = _px + 16;    // área das duas janelas (mecanismo + fiação)
var _cvy1 = _py + 48;
var _cvx2 = _px + 416;
var _cvy2 = _py + 272;

if (door_t < 0.99) {
    var _cw  = (_cvx2 - _cvx1) * (1 - door_t);   // a tampa encolhe em direção à dobradiça (esquerda)
    var _cx2 = _cvx1 + _cw;

    draw_rectangle_color(_cvx1, _cvy1, _cx2, _cvy2, _wood_top, _wood_top, _wood_bot, _wood_bot, false);

    if (_cw > 30) {
        draw_set_color(_brass_dk);
        draw_rectangle(_cvx1 + 10, _cvy1 + 10, _cx2 - 10, _cvy2 - 10, true);
        draw_set_alpha(0.35);
        draw_set_color(c_black);
        draw_rectangle(_cvx1 + 14, _cvy1 + 14, _cx2 - 14, _cvy2 - 14, true);
        draw_set_alpha(1);
    }

    draw_set_color(_brass);
    draw_rectangle(_cvx1, _cvy1, _cx2, _cvy2, true);

    // dobradiças
    draw_set_color(_brass_lt);
    draw_rectangle(_cvx1 - 3, _cvy1 + 30, _cvx1 + 5, _cvy1 + 50, false);
    draw_rectangle(_cvx1 - 3, _cvy2 - 50, _cvx1 + 5, _cvy2 - 30, false);

    // puxador e fechadura (só enquanto a tampa está larga)
    if (_cw > 120) {
        var _hx = _cx2 - 28;
        var _hy = (_cvy1 + _cvy2) / 2;
        draw_set_color(_brass);
        draw_roundrect_ext(_hx - 6, _hy - 26, _hx + 6, _hy + 26, 6, 6, false);
        draw_circle_color(_hx, _hy - 26, 7, _brass_lt, _brass_dk, false);
        draw_circle_color(_hx, _hy + 26, 7, _brass_lt, _brass_dk, false);
        draw_set_color(_brass_dk);
        draw_circle(_hx - 22, _hy, 5, false);
        draw_set_color(c_black);
        draw_circle(_hx - 22, _hy - 1, 1.6, false);
        draw_rectangle(_hx - 23, _hy, _hx - 21, _hy + 5, false);
    }

    // dica piscando quando a tampa está fechada
    if (door_t < 0.05) {
        draw_set_font(fnt_testes);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_alpha(0.45 + 0.35 * sin(current_time * 0.004));
        draw_set_color(_brass_lt);
        // se ficar grande/pequeno demais na sua fonte, ajuste 0.55
        draw_text_transformed((_cvx1 + _cvx2) / 2, _cvy2 - 26, "toque para abrir", 0.55, 0.55, 0);
        draw_set_alpha(1);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}

// botão de latão para FECHAR (só com a tampa aberta)
if (door_t > 0.95) {
    var _bx1 = _px + _w - 30;
    var _by1 = _py + 8;
    var _bx2 = _px + _w - 8;
    var _by2 = _py + 30;
    draw_rectangle_color(_bx1, _by1, _bx2, _by2, _brass_lt, _brass_lt, _brass, _brass, false);
    draw_set_color(_brass_dk);
    draw_rectangle(_bx1, _by1, _bx2, _by2, true);
    draw_set_color(make_color_rgb(60, 36, 10));
    draw_line_width(_bx1 + 6, _by1 + 6, _bx2 - 6, _by2 - 6, 2);
    draw_line_width(_bx1 + 6, _by2 - 6, _bx2 - 6, _by1 + 6, 2);
}

// clarão dourado da revelação
if (reveal_t > 0) {
    gpu_set_blendmode(bm_add);
    draw_set_alpha(reveal_t / 45 * 0.55);
    draw_set_color(make_color_rgb(255, 220, 140));
    draw_rectangle(_px, _py, _px + _w, _py + _h, false);
    gpu_set_blendmode(bm_normal);
}
draw_set_alpha(1);
matrix_set(matrix_world, matrix_build_identity());
