// ---------- camadas que o Room Start e o scr_show_dialog esperam ----------
if (!layer_exists("Buttons"))      layer_create(-100, "Buttons");
if (!layer_exists("Menu"))         layer_create(-150, "Menu");
if (!layer_exists("Text_Dialogs")) layer_create(-200, "Text_Dialogs");

depth = -5;   // na frente dos fundos da room, atrás do balde (-7) e do inventário (-10)

// ===================== CONFIGURAÇÃO (mexa aqui) =====================
// ordem em que as cortinas pegam fogo (0..3, da esquerda para a direita).
// ESTA É A ORDEM DA SENHA.
ignite_order  = [2, 0, 3, 1];
// texto da placa de cada cortina (da esquerda para a direita)
plaque_labels = ["I", "II", "III", "IV"];
// tecido de cada cortina: "algodao", "la" ou "cetim"
fabric_types  = ["algodao", "la", "cetim", "algodao"];

ignite_gap   = 480;   // frames entre uma ignição e a próxima (60 = 1 segundo)
grace_frames = 600;   // no começo da fase o fogo cresce na metade da velocidade

// rate = quanto o fogo cresce por frame (chega em 1 = salão perdido)
// hits = quantos baldes d'água o tecido pede
fabrics = {
    algodao: { rate: 0.0020, hits: 1 },
    la:      { rate: 0.0010, hits: 2 },
    cetim:   { rate: 0.0014, hits: 1 }
};

// sprites do balde (use os seus aqui se tiver: bucket_empty_sprite = spr_balde; ...)
bucket_empty_sprite = scr_get_bucket_sprite(false);
bucket_full_sprite  = scr_get_bucket_sprite(true);

// ---------- falas (edite à vontade) ----------
lines_intro_a = ["Isto é... o salão de eventos. Mas está inteiro.",
                 "Tecidos, mesas, lustres... como se o tempo tivesse voltado.",
                 "Estou vendo algo que já não existe."];
lines_intro_b = ["Há alguém ali, de costas. Ombros largos, sem pressa.",
                 "Nenhum grito. Nenhum desespero. Só calma."];
lines_intro_c = ["A chave girou duas vezes. Do lado de fora.",
                 "Quem acendeu... foi quem trancou?"];
lines_win_a   = ["O último foco se apagou. O salão está em silêncio, só cheiro de cinza.",
                 "Os tecidos queimaram em uma ordem. Como se alguém tivesse escolhido."];
lines_win_b   = ["Quatro placas, como os quatro níveis de urgência do hotel.",
                 "Preciso guardar essa ordem."];
lines_win_c   = ["Na água do chafariz, por um instante, vi alguém em chamas. Alguém com o meu casaco.",
                 "Foi só o reflexo das chamas... não foi?"];

// vozes abafadas durante a fase (t = frame desde o início da fase)
voices = [
    { t: 200,  txt: "- Abram a porta!" },
    { t: 520,  txt: "- O telefone está mudo!" },
    { t: 820,  txt: "- Tem alguém aí?!" },
    { t: 1100, txt: "- Está tudo trancado!" },
    { t: 1400, txt: "- Não consigo respirar..." }
];
// ====================================================================

// ordem como texto: "III, I, IV, II"
order_labels = [];
order_text   = "";
for (var i = 0; i < 4; i++) {
    array_push(order_labels, plaque_labels[ignite_order[i]]);
    order_text += order_labels[i];
    if (i < 3) order_text += ", ";
}

// ---------- geometria ----------
zone_x      = [120, 300, 516, 696];   // centro de cada cortina
zone_top    = 44;
zone_bottom = 214;
zone_w      = 96;
fountain_x  = 130;
fountain_y  = 560;
door_x      = 408;

zones = [];
for (var z = 0; z < 4; z++) {
    array_push(zones, { x: zone_x[z], type: fabric_types[z], state: "idle", inten: 0, hits: 0, splash: 0, steam: 0 });
}

// ---------- estado ----------
retry = variable_global_exists("fire_retry") && global.fire_retry;
global.fire_retry = false;

st = "title";          // title, intro_a, intro_fire, play, win, fail, dead
t  = 0;                // contador do estado atual
fs = 0;                // sub-etapa da abertura
ws = 0;                // sub-etapa do final
anim_t    = 0;
play_t    = 0;
ignite_timer = 0;
ignited   = 0;
wait_dialog = false;
was_locked  = false;

black_a    = 1;        // preto por cima de tudo
dark_a     = 0;        // escuridão da queda de energia
lights_on  = true;
flicker_t  = 0;
light_flick = false;
shake      = 0;
fail_flash = 0;
clock_min  = 44;
hl_zone    = -1;       // placa brilhando no final
reflect_t  = 0;        // reflexo no chafariz

caption   = "";
caption_t = 0;

sil_x = 0;  sil_start_x = 0;  sil_a = 0;  sil_flare = 0;

// ---------- lógica ----------
show_caption = function(_txt) {
    caption = _txt;
    caption_t = 170;
}

ignite_zone = function(_i) {
    zones[_i].state = "burning";
    zones[_i].inten = 0.25;
    ignited++;

    if (ignited == 1) clock_min = 46;   // 23:46

    if (ignited == 2) {                  // a energia cai
        lights_on = false;
        flicker_t = 80;
        show_caption("*A energia caiu.*");
    }
}

// ---------- desenho: fogo ----------
draw_flames = function(_cx, _base, _w, _h, _inten) {
    var _n = 7;
    for (var f = 0; f < _n; f++) {
        var _fx = _cx - _w / 2 + (f + 0.5) * (_w / _n);
        var _fh = _h * _inten * random_range(0.55, 1.0);
        var _bw = _w / _n * 0.8;
        var _sw = random_range(-4, 4);

        draw_set_color(make_color_rgb(200, 40, 10));
        draw_triangle(_fx - _bw, _base, _fx + _bw, _base, _fx + _sw, _base - _fh, false);
        draw_set_color(make_color_rgb(255, 140, 20));
        draw_triangle(_fx - _bw * 0.7, _base, _fx + _bw * 0.7, _base, _fx + _sw * 0.7, _base - _fh * 0.75, false);
        draw_set_color(make_color_rgb(255, 230, 120));
        draw_triangle(_fx - _bw * 0.4, _base, _fx + _bw * 0.4, _base, _fx + _sw * 0.4, _base - _fh * 0.45, false);
    }
}

// ---------- desenho: salão ----------
draw_hall = function() {
    var _brass    = make_color_rgb(181, 148, 70);
    var _brass_dk = make_color_rgb(110, 84, 34);
    var _brass_lt = make_color_rgb(232, 206, 130);

    // parede vinho com listras
    draw_rectangle_color(0, 0, room_width, 250,
        make_color_rgb(88, 24, 34), make_color_rgb(88, 24, 34),
        make_color_rgb(58, 14, 22), make_color_rgb(58, 14, 22), false);
    draw_set_alpha(0.10);
    draw_set_color(c_black);
    for (var x1 = 0; x1 < room_width; x1 += 24) {
        draw_rectangle(x1, 0, x1 + 8, 250, false);
    }
    draw_set_alpha(1);

    // lambri de madeira
    draw_rectangle_color(0, 190, room_width, 250,
        make_color_rgb(92, 46, 28), make_color_rgb(92, 46, 28),
        make_color_rgb(50, 23, 14), make_color_rgb(50, 23, 14), false);
    draw_set_color(_brass);
    draw_line_width(0, 190, room_width, 190, 3);
    draw_set_color(_brass_dk);
    draw_line_width(0, 250, room_width, 250, 3);

    // piso de tacos
    for (var y1 = 0; y1 < 14; y1++) {
        draw_set_color((y1 mod 2 == 0) ? make_color_rgb(122, 78, 46) : make_color_rgb(106, 68, 40));
        draw_rectangle(0, 253 + y1 * 28, room_width, 253 + (y1 + 1) * 28, false);
    }
    draw_set_alpha(0.25);
    draw_set_color(c_black);
    for (var x2 = 0; x2 < room_width; x2 += 64) {
        draw_line(x2, 253, x2 + (x2 - 408) * 0.35, room_height);
    }
    draw_set_alpha(1);

    // porta de vidro jateado
    draw_set_color(_brass_dk);
    draw_rectangle(door_x - 54, 96, door_x + 54, 252, false);
    draw_set_color(make_color_rgb(40, 24, 16));
    draw_rectangle(door_x - 48, 102, door_x + 48, 252, false);
    draw_rectangle_color(door_x - 44, 108, door_x - 2, 246,
        make_color_rgb(190, 205, 210), make_color_rgb(190, 205, 210),
        make_color_rgb(120, 140, 148), make_color_rgb(120, 140, 148), false);
    draw_rectangle_color(door_x + 2, 108, door_x + 44, 246,
        make_color_rgb(190, 205, 210), make_color_rgb(190, 205, 210),
        make_color_rgb(120, 140, 148), make_color_rgb(120, 140, 148), false);
    draw_set_color(_brass_lt);
    draw_circle(door_x - 8, 190, 4, false);
    draw_circle(door_x + 8, 190, 4, false);

    // relógio de parede (para às 23:46)
    draw_set_color(_brass);
    draw_circle(door_x, 62, 33, false);
    draw_set_color(make_color_rgb(244, 238, 220));
    draw_circle(door_x, 62, 28, false);
    draw_set_color(c_black);
    for (var h = 0; h < 12; h++) {
        var _a = h * 30;
        draw_line_width(door_x + lengthdir_x(23, _a), 62 + lengthdir_y(23, _a),
                        door_x + lengthdir_x(27, _a), 62 + lengthdir_y(27, _a), 2);
    }
    var _min_ang = 90 - clock_min * 6;
    var _hr_ang  = 90 - (11 + clock_min / 60) * 30;
    draw_line_width(door_x, 62, door_x + lengthdir_x(24, _min_ang), 62 + lengthdir_y(24, _min_ang), 2);
    draw_line_width(door_x, 62, door_x + lengthdir_x(15, _hr_ang),  62 + lengthdir_y(15, _hr_ang), 3);
    draw_circle(door_x, 62, 3, false);

    // lustres
    var _lit = (lights_on && !light_flick);
    for (var c = 0; c < 2; c++) {
        var _cx = (c == 0) ? 210 : 606;
        draw_set_color(_brass_dk);
        draw_line_width(_cx, 0, _cx, 40, 3);
        draw_set_color(_brass);
        draw_ellipse(_cx - 34, 38, _cx + 34, 58, true);
        draw_ellipse(_cx - 33, 39, _cx + 33, 57, true);
        for (var b = 0; b < 5; b++) {
            var _bx = _cx - 28 + b * 14;
            draw_set_color(_lit ? make_color_rgb(255, 238, 170) : make_color_rgb(60, 50, 40));
            draw_circle(_bx, 52, 4, false);
            if (_lit) {
                gpu_set_blendmode(bm_add);
                draw_set_alpha(0.10);
                draw_set_color(make_color_rgb(255, 220, 140));
                draw_circle(_bx, 52, 26, false);
                gpu_set_blendmode(bm_normal);
                draw_set_alpha(1);
            }
        }
    }

    // mesas do baile (toalha de algodão)
    for (var tb = 0; tb < 2; tb++) {
        var _tx = (tb == 0) ? 330 : 580;
        var _ty = (tb == 0) ? 410 : 450;
        draw_set_alpha(0.3);
        draw_set_color(c_black);
        draw_ellipse(_tx - 66, _ty + 10, _tx + 74, _ty + 36, false);
        draw_set_alpha(1);
        draw_set_color(make_color_rgb(240, 236, 226));
        draw_ellipse(_tx - 70, _ty - 26, _tx + 70, _ty + 22, false);
        draw_set_color(_brass);
        draw_ellipse(_tx - 70, _ty - 26, _tx + 70, _ty + 22, true);
        draw_set_color(make_color_rgb(250, 240, 210));
        draw_rectangle(_tx - 3, _ty - 22, _tx + 3, _ty - 6, false);
    }
}

// ---------- desenho: chafariz de mármore ----------
draw_fountain = function() {
    var _fx = fountain_x;
    var _fy = fountain_y;
    var _marble  = make_color_rgb(214, 210, 202);
    var _marble2 = make_color_rgb(170, 166, 160);
    var _brass   = make_color_rgb(181, 148, 70);
    var _water   = make_color_rgb(70, 140, 220);

    draw_set_alpha(0.3);
    draw_set_color(c_black);
    draw_ellipse(_fx - 100, _fy - 6, _fx + 100, _fy + 22, false);
    draw_set_alpha(1);

    // bacia inferior
    draw_set_color(_marble2);
    draw_ellipse(_fx - 92, _fy - 34, _fx + 92, _fy + 12, false);
    draw_set_color(_marble);
    draw_ellipse(_fx - 92, _fy - 40, _fx + 92, _fy + 4, false);
    draw_set_color(_brass);
    draw_ellipse(_fx - 92, _fy - 40, _fx + 92, _fy + 4, true);
    draw_set_color(_water);
    draw_ellipse(_fx - 80, _fy - 34, _fx + 80, _fy - 4, false);

    draw_set_alpha(0.4);
    draw_set_color(c_white);
    for (var r = 0; r < 4; r++) {
        var _sh = sin(anim_t * 0.05 + r) * 6;
        draw_line(_fx - 50 + r * 25 + _sh, _fy - 22 + r * 4, _fx - 34 + r * 25 + _sh, _fy - 22 + r * 4);
    }
    draw_set_alpha(1);

    // pedestal
    draw_set_color(_marble2);
    draw_rectangle(_fx - 14, _fy - 100, _fx + 14, _fy - 24, false);
    draw_set_color(_brass);
    draw_rectangle(_fx - 18, _fy - 62, _fx + 18, _fy - 56, false);

    // bacia superior
    draw_set_color(_marble2);
    draw_ellipse(_fx - 46, _fy - 118, _fx + 46, _fy - 88, false);
    draw_set_color(_marble);
    draw_ellipse(_fx - 46, _fy - 122, _fx + 46, _fy - 94, false);
    draw_set_color(_brass);
    draw_ellipse(_fx - 46, _fy - 122, _fx + 46, _fy - 94, true);
    draw_set_color(_water);
    draw_ellipse(_fx - 38, _fy - 118, _fx + 38, _fy - 98, false);

    // reflexo de alguém em chamas (cena final)
    if (reflect_t > 0) {
        var _ra = min(1, reflect_t / 30, (200 - reflect_t) / 30);
        draw_set_alpha(max(0, _ra) * 0.85);
        scr_capsule(_fx, _fy - 100, _fx, _fy - 112, 12, make_color_rgb(20, 18, 24));
        draw_set_color(make_color_rgb(20, 18, 24));
        draw_circle(_fx, _fy - 116, 5, false);
        draw_rectangle(_fx - 9, _fy - 120, _fx + 9, _fy - 118, false);
        draw_set_alpha(max(0, _ra));
        draw_flames(_fx, _fy - 100, 24, 26, 0.9);
        draw_set_alpha(1);
    }

    // jato d'água
    draw_set_color(make_color_rgb(190, 225, 255));
    for (var j = 0; j < 8; j++) {
        var _p  = ((anim_t * 1.5 + j * 9) mod 36) / 36;
        var _jx = _fx + sin(j * 1.3) * _p * 26 * ((j mod 2 == 1) ? 1 : -1);
        var _jy = _fy - 122 - sin(_p * pi) * 38 + _p * _p * 30;
        draw_set_alpha(1 - _p * 0.6);
        draw_circle(_jx, _jy, 2.5, false);
    }
    draw_set_alpha(1);
}

// ---------- desenho: cada cortina (com placa, fogo, fumaça e respingos) ----------
draw_zone = function(_i) {
    var _z    = zones[_i];
    var _x    = _z.x;
    var _w    = zone_w;
    var _top  = zone_top;
    var _bot  = zone_bottom;
    var _burn = (_z.state == "burning") ? _z.inten : 0;
    var _out  = (_z.state == "out");

    var _brass    = make_color_rgb(181, 148, 70);
    var _brass_dk = make_color_rgb(110, 84, 34);
    var _brass_lt = make_color_rgb(232, 206, 130);

    // cores por tipo de tecido
    var _c1, _c2;
    if (_z.type == "la") {
        _c1 = make_color_rgb(70, 92, 62);
        _c2 = make_color_rgb(44, 62, 40);
    }
    else if (_z.type == "cetim") {
        _c1 = make_color_rgb(40, 70, 170);
        _c2 = make_color_rgb(18, 36, 110);
    }
    else {
        _c1 = make_color_rgb(236, 226, 200);
        _c2 = make_color_rgb(196, 184, 156);
    }
    if (_out) {
        _c1 = make_color_rgb(40, 34, 30);
        _c2 = make_color_rgb(20, 16, 14);
    }
    else if (_burn > 0) {
        _c1 = merge_color(_c1, make_color_rgb(60, 24, 10), _burn * 0.6);
        _c2 = merge_color(_c2, make_color_rgb(30, 12, 6), _burn * 0.6);
    }

    // haste de latão e pano
    draw_set_color(_brass);
    draw_rectangle(_x - _w / 2 - 8, _top - 8, _x + _w / 2 + 8, _top - 2, false);
    draw_rectangle_color(_x - _w / 2, _top, _x + _w / 2, _bot, _c1, _c1, _c2, _c2, false);

    // dobras
    draw_set_alpha(0.25);
    draw_set_color(c_black);
    for (var k = 1; k < 6; k++) {
        var _fx = _x - _w / 2 + k * (_w / 6);
        draw_line_width(_fx, _top, _fx + ((k mod 2 == 0) ? 3 : -3), _bot, 2);
    }

    // textura de cada tecido
    if (!_out) {
        if (_z.type == "la") {
            for (var s = 0; s < 14; s++) {
                var _sx = _x - _w / 2 + 6 + ((s * 37) mod (_w - 12));
                var _sy = _top + 10 + ((s * 53) mod (_bot - _top - 20));
                draw_line(_sx, _sy, _sx + 6, _sy + 4);
            }
        }
        else if (_z.type == "algodao") {
            for (var s2 = _top + 8; s2 < _bot; s2 += 8) {
                draw_line(_x - _w / 2, s2, _x + _w / 2, s2);
            }
        }
        else {
            // brilho do cetim
            draw_set_alpha(0.28);
            draw_set_color(c_white);
            var _hx = _x - _w / 2 + 30;
            draw_triangle(_hx, _top, _hx + 14, _top, _hx - 10, _bot, false);
            draw_triangle(_hx, _top, _hx - 10, _bot, _hx - 24, _bot, false);
        }
    }
    draw_set_alpha(1);

    // barra em festão e cordão dourado
    draw_set_color(_c2);
    for (var sc = 0; sc < 6; sc++) {
        draw_circle(_x - _w / 2 + sc * (_w / 6) + _w / 12, _bot, _w / 12, false);
    }
    draw_set_color(_brass_lt);
    draw_line_width(_x - _w / 2, _top + 6, _x + _w / 2, _top + 6, 2);

    // buracos de queimado
    if (_out) {
        draw_set_color(c_black);
        for (var h = 0; h < 6; h++) {
            draw_circle(_x - _w / 2 + 10 + ((h * 29) mod (_w - 20)),
                        _top + 20 + ((h * 41) mod (_bot - _top - 40)),
                        6 + (h mod 3) * 3, false);
        }
    }

    // fogo, fumaça e barra de perigo
    if (_z.state == "burning") {
        draw_flames(_x, _bot, _w, (_bot - _top) * 1.05, _burn);

        for (var sm = 0; sm < 5; sm++) {
            var _p = ((anim_t * 0.7 + sm * 18 + _x) mod 90) / 90;
            draw_set_alpha((1 - _p) * 0.35 * _burn);
            draw_set_color(make_color_rgb(70, 70, 76));
            draw_circle(_x + sin(_p * 6 + sm) * 14, _bot - (_bot - _top) * _burn - _p * 60, 10 + _p * 16, false);
        }
        draw_set_alpha(1);

        draw_set_color(c_black);
        draw_rectangle(_x - 30, _top + 10, _x + 30, _top + 17, false);
        draw_set_color(merge_color(c_lime, c_red, _burn));
        draw_rectangle(_x - 29, _top + 11, _x - 29 + 58 * _burn, _top + 16, false);
    }

    // vapor depois de apagar
    if (_z.steam > 0) {
        var _sp = 1 - _z.steam / 150;
        for (var st2 = 0; st2 < 5; st2++) {
            draw_set_alpha((1 - _sp) * 0.4);
            draw_set_color(make_color_rgb(200, 200, 205));
            draw_circle(_x - 30 + st2 * 15 + sin(_sp * 8 + st2) * 6, _bot - 20 - _sp * 80 - st2 * 8, 10 + _sp * 14, false);
        }
        draw_set_alpha(1);
    }

    // respingos do balde
    if (_z.splash > 0) {
        var _q = 1 - _z.splash / 30;
        draw_set_color(make_color_rgb(150, 205, 255));
        for (var d = 0; d < 12; d++) {
            var _ang  = 20 + d * (140 / 11);
            var _dist = _q * 70 + (d mod 3) * 6;
            draw_set_alpha(1 - _q);
            draw_circle(_x + lengthdir_x(_dist, _ang),
                        (_top + _bot) / 2 + lengthdir_y(_dist, _ang) + _q * _q * 40,
                        3 * (1 - _q) + 1, false);
        }
        draw_set_alpha(1);
    }

    // placa numerada (brilha no final, na ordem do fogo)
    var _lit = (_i == hl_zone);
    if (_lit) {
        gpu_set_blendmode(bm_add);
        draw_set_alpha(0.5);
        draw_set_color(make_color_rgb(255, 200, 80));
        draw_circle(_x, _top - 24, 46, false);
        draw_circle(_x, _top - 24, 30, false);
        gpu_set_blendmode(bm_normal);
        draw_set_alpha(1);
    }
    draw_rectangle_color(_x - 24, _top - 38, _x + 24, _top - 14, _brass_lt, _brass_lt, _brass, _brass, false);
    draw_set_color(_brass_dk);
    draw_rectangle(_x - 24, _top - 38, _x + 24, _top - 14, true);
    draw_set_font(fnt_testes);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(60, 36, 10));
    // se os numerais ficarem grandes/pequenos demais na sua fonte, ajuste 0.6 e 0.9
    draw_text_transformed(_x, _top - 26, plaque_labels[_i], _lit ? 0.9 : 0.6, _lit ? 0.9 : 0.6, 0);
}

// ---------- desenho: silhueta misteriosa (só um vulto) ----------
draw_silhouette = function() {
    if (sil_a <= 0) return;

    var _x = sil_x;
    var _b = 318;   // pés
    var _c = make_color_rgb(6, 6, 10);

    draw_set_alpha(sil_a * 0.92);
    scr_capsule(_x - 9,  _b - 70,  _x - 11, _b,       14, _c);   // pernas
    scr_capsule(_x + 9,  _b - 70,  _x + 11, _b,       14, _c);
    scr_capsule(_x,      _b - 74,  _x,      _b - 116, 52, _c);   // tronco largo
    scr_capsule(_x - 26, _b - 112, _x + 26, _b - 112, 22, _c);   // ombros
    scr_capsule(_x - 30, _b - 108, _x - 32, _b - 66,  13, _c);   // braços
    scr_capsule(_x + 30, _b - 108, _x + 32, _b - 66,  13, _c);
    draw_set_color(_c);
    draw_circle(_x, _b - 138, 14, false);                        // cabeça
    draw_set_alpha(1);

    // faísca do fósforo
    if (sil_flare > 0) {
        draw_set_color(make_color_rgb(255, 170, 50));
        draw_circle(_x + 26, _b - 70, 2 + sil_flare * 5, false);
        gpu_set_blendmode(bm_add);
        draw_set_alpha(0.3 * sil_flare);
        draw_circle(_x + 26, _b - 70, 16, false);
        gpu_set_blendmode(bm_normal);
        draw_set_alpha(1);
    }
}

// ---------- desenho: escuridão, brilho do fogo, fumaça ----------
draw_atmosphere = function() {
    // queda de energia
    if (dark_a > 0.01) {
        draw_set_alpha(dark_a);
        draw_set_color(make_color_rgb(4, 4, 10));
        draw_rectangle(0, 0, room_width, room_height, false);
        draw_set_alpha(1);
    }

    // brilho do fogo (aditivo) e calor total
    var _heat = 0;
    gpu_set_blendmode(bm_add);
    for (var i = 0; i < array_length(zones); i++) {
        var _z = zones[i];
        if (_z.state == "burning") {
            _heat += _z.inten;
            for (var g = 0; g < 4; g++) {
                draw_set_alpha(0.05 + 0.03 * _z.inten);
                draw_set_color(make_color_rgb(255, 120, 30));
                draw_circle(_z.x, 170, (70 + g * 38) * (0.7 + _z.inten * 0.6), false);
            }
        }
    }
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);

    // fumaça acumulada no teto
    _heat = min(1, _heat / 3);
    if (_heat > 0.02) {
        draw_set_alpha(_heat * 0.5);
        draw_rectangle_color(0, 0, room_width, 230,
            make_color_rgb(60, 60, 66), make_color_rgb(60, 60, 66), c_black, c_black, false);
        draw_set_alpha(1);
    }
}

// ---------- desenho: legendas, cartela, preto ----------
draw_overlays = function() {
    // legendas (vozes, efeitos e dicas)
    if (caption_t > 0 && caption != "") {
        draw_set_font(fnt_testes);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_alpha(min(1, caption_t / 30));
        draw_set_color(c_black);
        draw_text_transformed(room_width / 2 + 2, 282, caption, 0.8, 0.8, 0);
        draw_set_color(make_color_rgb(255, 232, 190));
        draw_text_transformed(room_width / 2, 280, caption, 0.8, 0.8, 0);
        draw_set_alpha(1);
    }

    // clarão vermelho da falha
    if (fail_flash > 0) {
        draw_set_alpha(fail_flash * 0.5);
        draw_set_color(make_color_rgb(255, 60, 20));
        draw_rectangle(0, 0, room_width, room_height, false);
        draw_set_alpha(1);
    }

    // preto (abertura, falha e fechamento)
    if (black_a > 0) {
        draw_set_alpha(black_a);
        draw_set_color(c_black);
        draw_rectangle(0, 0, room_width, room_height, false);
        draw_set_alpha(1);
    }

    // cartela de abertura
    if (st == "title") {
        var _dur = retry ? 80 : 190;
        var _ta  = clamp(min(t, _dur - t) / 30, 0, 1);
        draw_set_font(fnt_testes);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_alpha(_ta);
        draw_set_color(make_color_rgb(235, 220, 190));
        draw_text_transformed(room_width / 2, 270, "SALÃO DE EVENTOS", 1.6, 1.6, 0);
        draw_text_transformed(room_width / 2, 320, "18 de setembro de 1993", 1, 1, 0);
        draw_text_transformed(room_width / 2, 360, "23:44", 1.2, 1.2, 0);
        draw_set_alpha(1);
    }

    // texto da falha
    if (st == "fail" && black_a > 0.6) {
        draw_set_font(fnt_testes);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_alpha(black_a);
        draw_set_color(make_color_rgb(235, 220, 190));
        draw_text_transformed(room_width / 2, room_height / 2, "A memória se desfaz...", 1.2, 1.2, 0);
        draw_set_alpha(1);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
