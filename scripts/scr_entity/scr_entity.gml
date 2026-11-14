//claramente Feito com IA --> parte vizual (entidade final).

/// Polígono preenchido (leque a partir de (_fx, _fy)) com contorno claro, para a silhueta preta aparecer sobre o preto.
function scr_ent_poly(_cx, _cy, _s, _pts, _fx, _fy, _fill, _edge) {
    var _n = array_length(_pts);

    draw_set_color(_fill);
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(_cx + _fx * _s, _cy + _fy * _s);
    for (var i = 0; i < _n; i += 2) {
        draw_vertex(_cx + _pts[i] * _s, _cy + _pts[i + 1] * _s);
    }
    draw_vertex(_cx + _pts[0] * _s, _cy + _pts[1] * _s);
    draw_primitive_end();

    draw_set_color(_edge);
    for (var j = 0; j < _n; j += 2) {
        var _k = (j + 2) mod _n;
        draw_line_width(_cx + _pts[j] * _s, _cy + _pts[j + 1] * _s, _cx + _pts[_k] * _s, _cy + _pts[_k + 1] * _s, max(1, 1.6 * _s));
    }
}

/// Polígono simétrico: _half = pontos do lado direito (de cima para baixo); o lado esquerdo é o espelho.
function scr_ent_mirror(_half) {
    var _out = [];
    var _n = array_length(_half);
    for (var i = 0; i < _n; i += 2) array_push(_out, _half[i], _half[i + 1]);
    for (var j = _n - 2; j >= 0; j -= 2) array_push(_out, -_half[j], _half[j + 1]);
    return _out;
}

/// Espelha os pontos no eixo x (mesma ordem).
function scr_ent_flipx(_pts) {
    var _o = [];
    for (var i = 0; i < array_length(_pts); i += 2) array_push(_o, -_pts[i], _pts[i + 1]);
    return _o;
}

/// Mão com garras. (_x, _y) = centro da palma; _hs = pixels por unidade; _side: -1 = esquerda, 1 = direita;
/// _spread: 0 a 1 (dedos abertos).
function scr_ent_hand(_x, _y, _hs, _side, _spread, _a) {
    var _ang = [25, 308, 288, 268, 248];     // polegar, indicador, médio, anelar, mindinho (mão direita; 0 = direita, 90 = cima, 270 = baixo)
    var _len = [42, 76, 88, 78, 60];
    var _dark = make_color_rgb(4, 4, 6);
    var _edge = make_color_rgb(82, 82, 94);
    var _claw = make_color_rgb(150, 150, 160);

    draw_set_alpha(_a);

    // Palma (contorno claro + preenchimento preto)
    draw_set_color(_edge);
    draw_ellipse(_x - 32 * _hs, _y - 38 * _hs, _x + 32 * _hs, _y + 38 * _hs, false);
    draw_set_color(_dark);
    draw_ellipse(_x - 29 * _hs, _y - 35 * _hs, _x + 29 * _hs, _y + 35 * _hs, false);

    for (var f = 0; f < 5; f++) {
        var _aa = _ang[f];
        if (f > 0) _aa = 278 + (_ang[f] - 278) * (0.7 + 0.8 * _spread);      // abre ou fecha o leque
        if (_side < 0) _aa = 180 - _aa;                                       // mão esquerda: espelhada
        var _bend = -17 * _side;                                              // as articulações se curvam como garras

        var _x0 = _x + lengthdir_x(24 * _hs, _aa);
        var _y0 = _y + lengthdir_y(24 * _hs, _aa);
        var _fl = _len[f] * _hs;
        var _x1 = _x0 + lengthdir_x(_fl * 0.5, _aa);
        var _y1 = _y0 + lengthdir_y(_fl * 0.5, _aa);
        var _x2 = _x1 + lengthdir_x(_fl * 0.35, _aa + _bend);
        var _y2 = _y1 + lengthdir_y(_fl * 0.35, _aa + _bend);
        var _tx = _x2 + lengthdir_x(_fl * 0.25 + 24 * _hs, _aa + _bend * 2.4);
        var _ty = _y2 + lengthdir_y(_fl * 0.25 + 24 * _hs, _aa + _bend * 2.4);

        // Dedo: contorno claro e, por cima, o preto
        draw_set_color(_edge);
        draw_line_width(_x0, _y0, _x1, _y1, 15 * _hs);
        draw_line_width(_x1, _y1, _x2, _y2, 11 * _hs);
        draw_set_color(_dark);
        draw_line_width(_x0, _y0, _x1, _y1, 11.5 * _hs);
        draw_line_width(_x1, _y1, _x2, _y2, 8 * _hs);

        // Garra: triângulo fino e curvo na ponta
        var _pa = _aa + _bend + 90;
        draw_set_color(_claw);
        draw_triangle(_x2 + lengthdir_x(4.5 * _hs, _pa), _y2 + lengthdir_y(4.5 * _hs, _pa),
                      _x2 - lengthdir_x(4.5 * _hs, _pa), _y2 - lengthdir_y(4.5 * _hs, _pa), _tx, _ty, false);
    }

    draw_set_alpha(1);
}

/// Corpo da entidade (sem as mãos). _jaw: 0 a 1 (boca abrindo). _mood: 0 = brava, 1 = feliz.
function scr_draw_entity_body(_cx, _cy, _s, _mood, _a, _jaw) {
    var _black = make_color_rgb(4, 4, 6);
    var _edge = make_color_rgb(78, 78, 90);
    var _tooth = make_color_rgb(222, 216, 204);

    // Brilho avermelhado atrás (aditivo), para a silhueta se destacar do fundo
    gpu_set_blendmode(bm_add);
    draw_set_color(make_color_rgb(110, 25, 0));
    draw_set_alpha(_a * 0.22);
    draw_circle(_cx, _cy + 120 * _s, 330 * _s, false);
    draw_set_alpha(_a * 0.18);
    draw_circle(_cx, _cy, 190 * _s, false);
    gpu_set_blendmode(bm_normal);

    // Fumaça na base
    draw_set_color(make_color_rgb(44, 44, 52));
    draw_set_alpha(_a * 0.35);
    for (var m = 0; m < 6; m++) {
        var _mx = -260 + m * 105;
        draw_ellipse(_cx + (_mx - 95) * _s, _cy + 560 * _s, _cx + (_mx + 95) * _s, _cy + 665 * _s, false);
    }
    draw_set_alpha(_a);

    // Manto, com a barra rasgada
    var _robe = scr_ent_mirror([0,45, 90,60, 120,100, 150,190, 185,300, 230,420, 290,540, 330,610,
                                300,642, 270,598, 240,648, 210,602, 180,652, 150,606, 120,646, 90,604, 60,648, 30,610, 0,640]);
    scr_ent_poly(_cx, _cy, _s, _robe, 0, 300, _black, _edge);

    // Mangas
    var _sl = [112,62, 200,88, 272,190, 292,258, 250,282, 226,226, 168,152, 108,130];
    scr_ent_poly(_cx, _cy, _s, _sl, 200, 170, _black, _edge);
    scr_ent_poly(_cx, _cy, _s, scr_ent_flipx(_sl), -200, 170, _black, _edge);

    // Gotas escorrendo das mangas e costelas
    draw_set_color(make_color_rgb(64, 64, 74));
    for (var side = -1; side <= 1; side += 2) {
        draw_line_width(_cx + side * 250 * _s, _cy + 282 * _s, _cx + side * 250 * _s, _cy + 350 * _s, max(1, 1.8 * _s));
        draw_line_width(_cx + side * 272 * _s, _cy + 262 * _s, _cx + side * 273 * _s, _cy + 322 * _s, max(1, 1.8 * _s));
        draw_line_width(_cx + side * 232 * _s, _cy + 262 * _s, _cx + side * 231 * _s, _cy + 306 * _s, max(1, 1.8 * _s));
        draw_line_width(_cx + side * 210 * _s, _cy + 240 * _s, _cx + side * 208 * _s, _cy + 290 * _s, max(1, 1.8 * _s));
        for (var r = 0; r < 5; r++) {
            var _ry = 118 + r * 30;
            draw_line_width(_cx, _cy + _ry * _s, _cx + side * (58 - r * 6) * _s, _cy + (_ry + 16) * _s, max(1, 2 * _s));
        }
    }
    draw_line_width(_cx, _cy + 100 * _s, _cx, _cy + 270 * _s, max(1, 2.4 * _s));    // coluna

    // Espinhos nos ombros
    var _br = [
        [118,52, 132,22, 126,-8, 140,-34],
        [142,72, 166,44, 160,12, 178,-14],
        [100,44, 104,14, 94,-14, 102,-44]
    ];
    draw_set_color(make_color_rgb(70, 70, 82));
    for (var b = 0; b < 3; b++) {
        var _p = _br[b];
        for (var sd = -1; sd <= 1; sd += 2) {
            for (var q = 0; q < 6; q += 2) {
                draw_line_width(_cx + sd * _p[q] * _s, _cy + _p[q + 1] * _s, _cx + sd * _p[q + 2] * _s, _cy + _p[q + 3] * _s, max(1, (3.2 - q * 0.5) * _s));
            }
        }
    }

    // Capuz e seu interior escuro
    var _hood = scr_ent_mirror([0,-102, 36,-97, 62,-72, 80,-36, 92,4, 104,44, 136,74, 96,92, 50,84, 0,92]);
    scr_ent_poly(_cx, _cy, _s, _hood, 0, -10, _black, _edge);
    draw_set_color(make_color_rgb(1, 1, 2));
    draw_ellipse(_cx - 52 * _s, _cy - 70 * _s, _cx + 52 * _s, _cy + 74 * _s, false);

    // Caveira
    draw_set_color(make_color_rgb(52, 52, 58));
    draw_ellipse(_cx - 34 * _s, _cy - 52 * _s, _cx + 34 * _s, _cy + 44 * _s, false);
    draw_set_color(make_color_rgb(112, 112, 124));
    draw_ellipse(_cx - 34 * _s, _cy - 52 * _s, _cx + 34 * _s, _cy + 44 * _s, true);

    // Órbitas e nariz
    draw_set_color(make_color_rgb(2, 2, 3));
    draw_ellipse(_cx - 29 * _s, _cy - 38 * _s, _cx - 7 * _s, _cy - 12 * _s, false);
    draw_ellipse(_cx + 7 * _s, _cy - 38 * _s, _cx + 29 * _s, _cy - 12 * _s, false);
    draw_triangle(_cx, _cy - 6 * _s, _cx - 6 * _s, _cy + 12 * _s, _cx + 6 * _s, _cy + 12 * _s, false);

    // Olhos
    if (_mood == 0) {
        gpu_set_blendmode(bm_add);
        draw_set_color(make_color_rgb(255, 110, 20));
        for (var e = -1; e <= 1; e += 2) {
            draw_set_alpha(_a * 0.28);
            draw_circle(_cx + e * 18 * _s, _cy - 25 * _s, 24 * _s, false);
            draw_set_alpha(_a);
            draw_circle(_cx + e * 18 * _s, _cy - 25 * _s, 7.5 * _s, false);
        }
        gpu_set_blendmode(bm_normal);
        draw_set_alpha(_a);
        draw_set_color(make_color_rgb(255, 214, 150));
        draw_circle(_cx - 18 * _s, _cy - 25 * _s, 3 * _s, false);
        draw_circle(_cx + 18 * _s, _cy - 25 * _s, 3 * _s, false);
    } else {
        draw_set_color(make_color_rgb(255, 205, 120));
        for (var e2 = -1; e2 <= 1; e2 += 2) {
            draw_line_width(_cx + e2 * 18 * _s - 9 * _s, _cy - 22 * _s, _cx + e2 * 18 * _s, _cy - 31 * _s, max(1, 3 * _s));
            draw_line_width(_cx + e2 * 18 * _s, _cy - 31 * _s, _cx + e2 * 18 * _s + 9 * _s, _cy - 22 * _s, max(1, 3 * _s));
        }
    }

    // Boca
    if (_mood == 0) {
        var _open = clamp(_jaw, 0, 1);
        var _jd = _open * 62;                       // quanto a mandíbula desce (unidades)

        // Interior da boca (escuro, com brilho vermelho quando abre)
        if (_jd > 0) {
            draw_set_color(make_color_rgb(2, 0, 0));
            draw_rectangle(_cx - 30 * _s, _cy + 24 * _s, _cx + 30 * _s, _cy + (30 + _jd) * _s, false);
            gpu_set_blendmode(bm_add);
            draw_set_color(make_color_rgb(110, 14, 0));
            draw_set_alpha(_a * 0.55 * _open);
            draw_ellipse(_cx - 24 * _s, _cy + 30 * _s, _cx + 24 * _s, _cy + (24 + _jd) * _s, false);
            gpu_set_blendmode(bm_normal);
            draw_set_alpha(_a);
        }

        // Mandíbula (desce com _jaw)
        var _jp = [-30, 28 + _jd, 30, 28 + _jd, 27, 60 + _jd, 0, 78 + _jd, -27, 60 + _jd];
        scr_ent_poly(_cx, _cy, _s, _jp, 0, 50 + _jd, make_color_rgb(46, 46, 52), make_color_rgb(112, 112, 124));

        // Dentes de cima (apontam para baixo) e de baixo (apontam para cima)
        draw_set_color(_tooth);
        for (var t = 0; t < 8; t++) {
            var _tx = -26 + t * 7.4;
            var _tl = 10 + ((t == 1 || t == 6) ? 6 : (t mod 2) * 3);
            draw_triangle(_cx + _tx * _s, _cy + 26 * _s, _cx + (_tx + 7) * _s, _cy + 26 * _s, _cx + (_tx + 3.5) * _s, _cy + (26 + _tl) * _s, false);
            draw_triangle(_cx + _tx * _s, _cy + (28 + _jd) * _s, _cx + (_tx + 7) * _s, _cy + (28 + _jd) * _s, _cx + (_tx + 3.5) * _s, _cy + (28 + _jd - _tl + 2) * _s, false);
        }
    } else {
        // Feliz: sorriso largo com dentes
        draw_set_color(make_color_rgb(2, 2, 3));
        draw_ellipse(_cx - 30 * _s, _cy + 22 * _s, _cx + 30 * _s, _cy + 46 * _s, false);
        draw_set_color(_tooth);
        for (var t2 = 0; t2 < 9; t2++) {
            var _sx = -28 + t2 * 7;
            var _curve = 9 * (1 - sqr((_sx + 3.5) / 31));
            draw_triangle(_cx + _sx * _s, _cy + (24 + _curve) * _s, _cx + (_sx + 6.4) * _s, _cy + (24 + _curve) * _s, _cx + (_sx + 3.2) * _s, _cy + (24 + _curve + 9) * _s, false);
        }
        for (var u = -30; u < 30; u += 6) {
            var _ua = 24 + 9 * (1 - sqr(u / 31));
            var _ub = 24 + 9 * (1 - sqr((u + 6) / 31));
            draw_line_width(_cx + u * _s, _cy + _ua * _s, _cx + (u + 6) * _s, _cy + _ub * _s, max(1, 1.6 * _s));
        }
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    gpu_set_blendmode(bm_normal);
}

/// A entidade inteira (corpo + mãos). (_cx, _cy) = centro da caveira; _s = pixels por unidade;
/// _mood: 0 = brava, 1 = feliz; _a = opacidade;
/// _reach: 0 a 1 = as mãos vêm em direção à tela; _jaw: 0 a 1 = boca abrindo.
function scr_draw_entity(_cx, _cy, _s, _mood, _a, _reach = 0, _jaw = 0) {
    scr_draw_entity_body(_cx, _cy, _s, _mood, _a, _jaw);

    // Mãos: ficam nas laterais do corpo e, com _reach, vêm para a tela (maiores, mais ao centro e abertas)
    var _spread = (_mood == 0) ? 0.4 + 0.6 * _reach : 0.15;
    var _k = _reach * _reach;                                     // acelera no fim
    for (var _side = -1; _side <= 1; _side += 2) {
        var _bx = _cx + _side * 262 * _s;
        var _by = _cy + 270 * _s;
        var _tx = room_width / 2 + _side * room_width * 0.27;     // para onde a mão vai (perto da câmera)
        var _ty = room_height * 0.74;
        var _hx = lerp(_bx, _tx, _k);
        var _hy = lerp(_by, _ty, _k);
        var _hs = lerp(_s, room_height / 200, _k);
        scr_ent_hand(_hx, _hy, _hs, _side, _spread, _a);
    }
}