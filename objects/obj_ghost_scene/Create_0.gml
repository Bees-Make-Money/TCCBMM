// ---------- camadas que o Room Start e o scr_show_dialog esperam ----------
if (!layer_exists("Buttons"))      layer_create(-100, "Buttons");
if (!layer_exists("Menu"))         layer_create(-150, "Menu");
if (!layer_exists("Text_Dialogs")) layer_create(-200, "Text_Dialogs");

depth = -5;   // na frente dos fundos da room, atrás do inventário (-10)

// ===================== CONFIGURAÇÃO (mexa aqui) =====================
ghost_count   = 9;      // de 1 a 9 (as 9 almas do hotel)
spawn_gap     = 170;    // frames entre um fantasma aparecer e o próximo (60 = 1 segundo)
charge_frames = 80;     // frames com a luz em cima para banir (60 = 1 segundo)
speed_min     = 0.20;   // velocidade de aproximação (pixels por frame)
speed_max     = 0.30;
catch_radius  = 62;     // distância do detetive em que o fantasma "pega" ele
ghost_min_alpha  = 0.10;  // brilho fraco dos fantasmas no escuro (0 = totalmente invisíveis)
light_radius_override = -1;  // -1 = medir sozinho; ou um raio em pixels (ex.: 120) se a medição errar
ambient_dark     = 0.80;  // escuridão da sala (0 a 1)

on_fail    = "retry";   // "retry" = recomeça a sala  |  "death" = usa o obj_death
death_text = "Eles nunca deixaram ninguém sair.";   // texto do obj_death se on_fail = "death"

scare_times = [420, 1100];   // sustos de ambiente (frames desde o começo da caça)

// recompensa ao banir todos (deixe "" para não dar nenhum item)
reward_item   = "";
reward_sprite = -1;   // seu sprite do item (-1 = quadrado provisório)

lines_intro = ["O livro queimou frio nas minhas mãos... e então o mundo escureceu.",
               "Esta sala não existe no hotel. Mas conheço este cheiro de cinza.",
               "Eu não estou sozinho."];
lines_win   = ["O silêncio voltou. As vozes se calaram.",
               "Em algum lugar, uma fechadura estalou. Parece que o caminho para a próxima sala se abriu."];

// o que cada fantasma sussurra ao ser banido
whispers = ["- Eu só queria ir para casa...",
            "- Estava tudo trancado... tudo.",
            "- Fazia uma semana que eu não dormia.",
            "- O baile ia ser lindo.",
            "- Ninguém veio... ninguém veio.",
            "- Você consegue nos ouvir?",
            "- Está tão quente...",
            "- Não era para terminar assim.",
            "- Obrigado por nos ver."];
// ====================================================================

// ---------- geometria ----------
cx = room_width / 2;        // onde o detetive está
cy = room_height / 2 + 20;
ring_rx = 340;
ring_ry = 250;

// ---------- estado ----------
retry = variable_global_exists("ghost_retry") && global.ghost_retry;
global.ghost_retry = false;

st  = "fade_in";     // fade_in, play, fail, win, dead
t   = 0;
ws  = 0;
anim_t  = 0;
play_t  = 0;
wait_dialog  = false;
play_started = false;
banished = 0;

black_a  = 1;
caption  = "";
caption_t = 0;

scare_t = 0;  scare_len = 1;  scare_fatal = false;
flash_t = 0;  flash_x = 0;    flash_y = 0;

fl_on = false;  lx = 0;  ly = 0;

// raio e centro da luz da lanterna normal, medidos do sprite dela
var _area = scr_ghost_measure_light(spr_flashlight_light);
light_r   = (light_radius_override > 0) ? light_radius_override : _area.r;
light_cdx = _area.cdx;
light_cdy = _area.cdy;

// ---------- fantasmas ----------
// ordem em que eles aparecem (embaralhada)
spawn_order = [];
for (var i = 0; i < ghost_count; i++) array_push(spawn_order, i);
for (var i2 = ghost_count - 1; i2 > 0; i2--) {
    var _j = irandom(i2);
    var _tmp = spawn_order[i2];
    spawn_order[i2] = spawn_order[_j];
    spawn_order[_j] = _tmp;
}

ghosts = [];
var _a0 = random(360);
for (var g = 0; g < ghost_count; g++) {
    var _ang = _a0 + g * (360 / ghost_count);
    var _gx  = cx + lengthdir_x(ring_rx, _ang);
    var _gy  = cy + lengthdir_y(ring_ry, _ang);
    array_push(ghosts, {
        style: g,                  // define os acessórios (0 a 8)
        x: _gx,
        y: _gy,
        dist0: point_distance(_gx, _gy, cx, cy),
        spd: random_range(speed_min, speed_max),
        state: "wait",             // wait, active, banish, gone
        charge: 0,
        vis: 0,
        lit: false,
        scale: 0.7,
        fade: 1
    });
}

// ---------- lógica ----------
show_caption = function(_txt) {
    caption = _txt;
    caption_t = 170;
}

trigger_scare = function(_len, _fatal) {
    scare_t = _len;
    scare_len = _len;
    scare_fatal = _fatal;
    scr_play_sfx("snd_jumpscare");
}

// ---------- desenho: o salão queimado ----------
draw_room_art = function() {
    // parede carbonizada
    draw_rectangle_color(0, 0, room_width, 300,
        make_color_rgb(40, 18, 20), make_color_rgb(40, 18, 20),
        make_color_rgb(22, 10, 12), make_color_rgb(22, 10, 12), false);

    // papel de parede rasgado
    draw_set_alpha(0.25);
    draw_set_color(make_color_rgb(10, 6, 6));
    for (var x1 = 0; x1 < room_width; x1 += 38) {
        draw_rectangle(x1, 0, x1 + 14 + (x1 mod 3) * 6, 300 - ((x1 * 7) mod 80), false);
    }
    draw_set_alpha(1);

    // janelas tapadas com tábuas
    for (var w = 0; w < 3; w++) {
        var _wx = 150 + w * 258;
        draw_set_color(make_color_rgb(8, 10, 22));
        draw_rectangle(_wx - 40, 60, _wx + 40, 220, false);
        draw_set_color(make_color_rgb(60, 40, 28));
        draw_line_width(_wx - 46, 100, _wx + 46, 90 + w * 6, 8);
        draw_line_width(_wx - 46, 150, _wx + 46, 160 - w * 5, 8);
    }

    // piso de tábuas escuras
    for (var y1 = 0; y1 < 12; y1++) {
        draw_set_color((y1 mod 2 == 0) ? make_color_rgb(44, 30, 22) : make_color_rgb(36, 24, 18));
        draw_rectangle(0, 300 + y1 * 28, room_width, 300 + (y1 + 1) * 28, false);
    }
    draw_set_alpha(0.3);
    draw_set_color(c_black);
    for (var x2 = 0; x2 < room_width; x2 += 64) {
        draw_line(x2, 300, x2 + (x2 - 408) * 0.35, room_height);
    }

    // círculo de giz com 9 marcas
    var _ccy = cy + 30;
    draw_set_alpha(0.45);
    draw_set_color(make_color_rgb(220, 220, 230));
    draw_ellipse(cx - 170, _ccy - 64, cx + 170, _ccy + 64, true);
    draw_ellipse(cx - 166, _ccy - 61, cx + 166, _ccy + 61, true);
    for (var m = 0; m < 9; m++) {
        var _a = m * 40;
        draw_circle(cx + lengthdir_x(170, _a), _ccy + lengthdir_y(64, _a), 4, false);
    }
    draw_set_alpha(1);

    // o livro no chão, no centro
    draw_set_color(make_color_rgb(70, 30, 30));
    draw_rectangle(cx - 14, _ccy - 8, cx + 14, _ccy + 8, false);
    draw_set_color(make_color_rgb(150, 120, 50));
    draw_rectangle(cx - 14, _ccy - 8, cx + 14, _ccy + 8, true);
    draw_line(cx, _ccy - 8, cx, _ccy + 8);
}

// ---------- desenho: um fantasma (corpo, rosto oco e acessórios) ----------
draw_ghost_figure = function(_x, _y, _s, _style, _a) {
    var _sway = sin(anim_t * 0.06 + _style) * 3 * _s;
    var _bx   = _x + _sway;
    var _col  = make_color_rgb(205, 222, 245);
    var _dk   = make_color_rgb(60, 70, 100);
    var _w1   = (_style == 2) ? 18 : 26;   // o negociador é magro

    draw_set_alpha(_a);

    // braços
    scr_capsule(_bx - _w1 * _s, _y - 74 * _s, _bx - (_w1 + 12) * _s, _y - 40 * _s, 8 * _s, _col);
    scr_capsule(_bx + _w1 * _s, _y - 74 * _s, _bx + (_w1 + 12) * _s, _y - 40 * _s, 8 * _s, _col);

    // corpo: lençol que se alarga para baixo
    draw_set_color(_col);
    draw_triangle(_bx - _w1 * _s, _y - 78 * _s, _bx + _w1 * _s, _y - 78 * _s, _bx - (_w1 + 12) * _s, _y, false);
    draw_triangle(_bx + _w1 * _s, _y - 78 * _s, _bx - (_w1 + 12) * _s, _y, _bx + (_w1 + 12) * _s, _y, false);

    // barra esfarrapada
    for (var i = 0; i < 5; i++) {
        draw_circle(_bx - (_w1 + 6) * _s + i * ((_w1 + 6) * _s / 2) + sin(anim_t * 0.1 + i) * 2,
                    _y + 2, 8 * _s, false);
    }

    // cabeça
    draw_set_color(_col);
    draw_circle(_bx, _y - 94 * _s, 17 * _s, false);

    // olhos e boca ocos
    draw_set_color(c_black);
    draw_ellipse(_bx - 9 * _s, _y - 100 * _s, _bx - 3 * _s, _y - 90 * _s, false);
    draw_ellipse(_bx + 3 * _s, _y - 100 * _s, _bx + 9 * _s, _y - 90 * _s, false);
    draw_ellipse(_bx - 4 * _s, _y - 88 * _s, _bx + 4 * _s, _y - 76 * _s, false);

    // acessórios (um por vítima do hotel)
    draw_set_color(_dk);
    switch (_style) {
        case 0:   // gravata
            draw_triangle(_bx - 4 * _s, _y - 76 * _s, _bx + 4 * _s, _y - 76 * _s, _bx, _y - 48 * _s, false);
        break;
        case 1:   // cartola
            draw_rectangle(_bx - 14 * _s, _y - 128 * _s, _bx + 14 * _s, _y - 108 * _s, false);
            draw_rectangle(_bx - 22 * _s, _y - 110 * _s, _bx + 22 * _s, _y - 106 * _s, false);
        break;
        case 2:   // óculos
            draw_circle(_bx - 6 * _s, _y - 96 * _s, 6 * _s, true);
            draw_circle(_bx + 6 * _s, _y - 96 * _s, 6 * _s, true);
        break;
        case 3:
        case 4:   // avental
            draw_rectangle(_bx - 14 * _s, _y - 62 * _s, _bx + 14 * _s, _y - 14 * _s, false);
        break;
        case 5:   // lenço na cabeça
            draw_triangle(_bx - 18 * _s, _y - 100 * _s, _bx + 18 * _s, _y - 100 * _s, _bx, _y - 122 * _s, false);
        break;
        case 6:   // boné
            draw_rectangle(_bx - 16 * _s, _y - 114 * _s, _bx + 16 * _s, _y - 106 * _s, false);
            draw_rectangle(_bx, _y - 108 * _s, _bx + 24 * _s, _y - 105 * _s, false);
        break;
        default:  // quepe
            draw_rectangle(_bx - 17 * _s, _y - 116 * _s, _bx + 17 * _s, _y - 106 * _s, false);
            draw_rectangle(_bx - 20 * _s, _y - 108 * _s, _bx + 20 * _s, _y - 105 * _s, false);
        break;
    }

    draw_set_alpha(1);
}

// ---------- desenho: todos os fantasmas e o anel de banimento ----------
draw_ghosts = function() {
    for (var i = 0; i < array_length(ghosts); i++) {
        var _g = ghosts[i];
        if (_g.state == "wait" || _g.state == "gone") continue;

        var _a;
        if (_g.state == "banish") {
            _a = _g.fade * 0.9;
        }
        else {
            var _dist = point_distance(_g.x, _g.y, cx, cy);
            var _near = clamp(1 - _dist / 220, 0, 1) * 0.30;
            _a = max(_g.vis, _near, ghost_min_alpha) * 0.92;
        }

        draw_ghost_figure(_g.x, _g.y, _g.scale, _g.style, _a);

        // anel dourado enchendo (quanto falta para banir)
        if (_g.state == "active" && _g.charge > 0) {
            var _gx = _g.x;
            var _gy = _g.y - 45 * _g.scale;
            var _rr = 34 * _g.scale;
            var _steps = ceil(48 * _g.charge);
            draw_set_alpha(0.9);
            draw_set_color(make_color_rgb(255, 240, 160));
            for (var k = 0; k < _steps; k++) {
                var _a1 = 90 - k * (360 / 48);
                var _a2 = 90 - (k + 1) * (360 / 48);
                draw_line_width(_gx + lengthdir_x(_rr, _a1), _gy + lengthdir_y(_rr, _a1),
                                _gx + lengthdir_x(_rr, _a2), _gy + lengthdir_y(_rr, _a2), 3);
            }
            draw_set_alpha(1);
        }
    }
}

// ---------- desenho: rosto do susto (grita na tela inteira) ----------
draw_scare_face = function(_x, _y, _s) {
    // cabelo escorrido
    draw_set_color(make_color_rgb(14, 14, 20));
    for (var i = 0; i < 9; i++) {
        draw_line_width(_x - 50 * _s + i * 12 * _s, _y - 70 * _s,
                        _x - 62 * _s + i * 15 * _s + sin(anim_t * 0.4 + i) * 5 * _s, _y + 20 * _s, 5 * _s);
    }

    // rosto pálido
    draw_set_color(make_color_rgb(225, 235, 250));
    draw_ellipse(_x - 40 * _s, _y - 56 * _s, _x + 40 * _s, _y + 56 * _s, false);
    draw_set_alpha(0.25);
    draw_set_color(c_black);
    draw_ellipse(_x - 40 * _s, _y + 8 * _s, _x + 40 * _s, _y + 56 * _s, false);
    draw_set_alpha(1);

    // olhos ocos com lágrimas escuras
    draw_set_color(c_black);
    draw_ellipse(_x - 28 * _s, _y - 26 * _s, _x - 8 * _s, _y + 4 * _s, false);
    draw_ellipse(_x + 8 * _s, _y - 26 * _s, _x + 28 * _s, _y + 4 * _s, false);
    draw_line_width(_x - 18 * _s, _y + 4 * _s, _x - 22 * _s, _y + 50 * _s, 3 * _s);
    draw_line_width(_x + 18 * _s, _y + 4 * _s, _x + 22 * _s, _y + 50 * _s, 3 * _s);

    // pontos de luz nos olhos
    draw_set_color(c_white);
    draw_circle(_x - 18 * _s, _y - 12 * _s, 2.5 * _s, false);
    draw_circle(_x + 18 * _s, _y - 12 * _s, 2.5 * _s, false);

    // boca aberta num grito
    draw_set_color(c_black);
    draw_ellipse(_x - 16 * _s, _y + 18 * _s, _x + 16 * _s, _y + 52 * _s, false);
    draw_set_color(make_color_rgb(200, 205, 190));
    draw_triangle(_x - 10 * _s, _y + 22 * _s, _x - 3 * _s, _y + 22 * _s, _x - 7 * _s, _y + 32 * _s, false);
    draw_triangle(_x + 3 * _s, _y + 22 * _s, _x + 10 * _s, _y + 22 * _s, _x + 6 * _s, _y + 34 * _s, false);
    draw_triangle(_x - 8 * _s, _y + 50 * _s, _x - 1 * _s, _y + 50 * _s, _x - 5 * _s, _y + 41 * _s, false);
}