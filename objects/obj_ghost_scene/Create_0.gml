if (!layer_exists("Buttons"))      layer_create(-100, "Buttons");
if (!layer_exists("Menu"))         layer_create(-150, "Menu");
if (!layer_exists("Text_Dialogs")) layer_create(-200, "Text_Dialogs");

depth = -5;   // na frente dos fundos da room, atrás do inventário (-10)

// ===================== CONFIGURAÇÃO (mexa aqui) =====================
ghost_count   = 9;       // de 1 a 9 (as 9 almas do hotel)
first_spawn   = 45;      // frames até o primeiro fantasma aparecer
spawn_gap     = 100;     // frames entre um fantasma e o próximo (V1: 170)
charge_frames = 58;      // frames com a luz em cima para banir (V1: 80)

speed_min       = 0.38;  // velocidade de arrasto, pixels por frame (V1: 0.20)
speed_max       = 0.58;  //                                        (V1: 0.30)
ramp_per_banish = 0.07;  // cada fantasma banido deixa os outros 7% mais rápidos
rush_dist       = 210;   // abaixo dessa distância do detetive o fantasma ACELERA
rush_mult       = 2.0;   // quantas vezes mais rápido ele fica na reta final
jump_min        = 38;    // intervalo (frames) entre pulos no escuro
jump_max        = 85;
jump_px_min     = 16;    // tamanho de cada pulo, em pixels
jump_px_max     = 30;
catch_radius    = 70;    // distância em que o fantasma "pega" o detetive

blackout_min = 420;      // intervalo entre apagões totais (frames)
blackout_max = 700;
blackout_len = 26;       // duração de cada apagão

ghost_min_alpha = 0.08;  // brilho do corpo no escuro (0 = invisível; os OLHOS aparecem sempre)
light_radius_override = -1;   // -1 = medir sozinho; ou um raio em pixels (ex.: 120)
ambient_dark = 0.80;     // escuridão da sala (0 a 1)

on_fail    = "retry";    // "retry" = recomeça a sala  |  "death" = usa o obj_death
death_text = "Eles nunca deixaram ninguém sair.";

scare_times = [300, 760];   // sustos de ambiente (frames desde o começo da caçada)

// recompensa ao banir todos (deixe "" para não dar nenhum item)
reward_item   = "";
reward_sprite = -1;

// ---- arte própria (opcional): é o caminho para MAIS realismo ----
ghost_sprite = -1;   // sprite com 9 subimagens (uma por fantasma, de 0 a 8). Origem: centro embaixo
scare_sprite = -1;   // sprite animado do susto (cobre a tela). Origem: centro

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

black_a   = 1;
caption   = "";
caption_t = 0;

scare_t = 0;  scare_len = 1;  scare_fatal = false;
flash_t = 0;  flash_x = 0;    flash_y = 0;

fl_on = false;  lx = 0;  ly = 0;

// efeitos de terror
heart_t     = 0;        // contador do batimento
heart_pulse = 0;        // pulso da última batida (0 a 1)
min_dist    = 9999;     // distância do fantasma mais próximo
static_t    = 0;        // quadros de estática
blackout_t  = 0;        // quadros de apagão
next_blackout = 420;    // quando acontece o próximo apagão
bo_restore  = false;    // a lanterna estava ligada antes do apagão?

// raio e centro da luz da lanterna normal, medidos do sprite dela
var _area = scr_ghost_measure_light(spr_flashlight_light);
light_r   = (light_radius_override > 0) ? light_radius_override : _area.r;
light_cdx = _area.cdx;
light_cdy = _area.cdy;

// ---------- fantasmas ----------
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
        fade: 1,
        jt: irandom_range(jump_min, jump_max),   // contador do próximo pulo
        glitch: 0                                // quadros de falha de imagem
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
    static_t = 12;
    scr_play_sfx("snd_jumpscare");
}

// o fantasma dá um pulo na direção do detetive (com falha de imagem)
ghost_jump = function(_g, _mult) {
    var _dir = point_direction(_g.x, _g.y, cx, cy);
    var _px  = random_range(jump_px_min, jump_px_max) * _mult;
    _g.x += lengthdir_x(_px, _dir);
    _g.y += lengthdir_y(_px, _dir);
    _g.glitch = 10;
    static_t = max(static_t, 4);
    scr_play_sfx("snd_ghost_step");
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

    // marcas de mãos sujas de fuligem e sangue, com escorridos
    draw_set_alpha(0.55);
    draw_set_color(make_color_rgb(70, 8, 8));
    for (var hp = 0; hp < 5; hp++) {
        var _hxp = 60 + hp * 165 + ((hp * 31) mod 40);
        var _hyp = 235 + ((hp * 23) mod 30);
        draw_circle(_hxp, _hyp, 9, false);
        for (var fg = 0; fg < 4; fg++) {
            draw_line_width(_hxp - 7 + fg * 5, _hyp - 6, _hxp - 8 + fg * 5, _hyp - 24 - (fg mod 2) * 5, 3);
        }
        draw_line_width(_hxp + 8, _hyp, _hxp + 18, _hyp - 10, 3);
        draw_line_width(_hxp, _hyp + 9, _hxp + 1, _hyp + 40 + (hp mod 3) * 12, 2);
    }

    // arranhões na parede
    draw_set_alpha(0.4);
    draw_set_color(c_black);
    for (var sc = 0; sc < 4; sc++) {
        var _sx = 90 + sc * 200;
        for (var sl = 0; sl < 4; sl++) {
            draw_line_width(_sx + sl * 7, 110 + sc * 6, _sx + sl * 7 + 4, 190 + sc * 8, 2);
        }
    }
    draw_set_alpha(1);

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

// ---------- desenho: um fantasma (magro, queimado, de membros longos) ----------
draw_ghost_figure = function(_x, _y, _s, _style, _a, _g) {
    var _t    = anim_t;
    var _near = clamp(1 - point_distance(_g.x, _g.y, cx, cy) / 220, 0, 1);   // 0 longe, 1 perto
    var _jit  = (_g.glitch > 0) ? random_range(-5, 5) * _s : 0;
    var _bx   = _x + _jit + sin(_t * 0.045 + _style) * 3 * _s;

    // arte própria, se você forneceu
    if (ghost_sprite != -1) {
        draw_sprite_ext(ghost_sprite, _style, _bx, _y, _s, _s, 0, c_white, _a);
        return;
    }

    var _lean  = 6 * _s * _near;     // inclina-se para a frente quando chega perto
    var _skin  = make_color_rgb(176, 190, 200);
    var _soot  = make_color_rgb(18, 16, 20);
    var _cloth = make_color_rgb(32, 30, 38);
    var _burn  = make_color_rgb(70, 28, 16);

    draw_set_alpha(_a);

    // tiras de pano queimado até o chão (ele flutua)
    for (var k = 0; k < 9; k++) {
        var _kx  = _bx - 24 * _s + k * 6 * _s;
        var _len = (46 + ((k * 17 + _style * 7) mod 30)) * _s;
        var _sw  = sin(_t * 0.08 + k * 1.7) * 5 * _s;
        draw_set_color((k mod 3 == 0) ? _burn : _soot);
        draw_line_width(_kx, _y - 50 * _s, _kx + _sw, _y - 50 * _s + _len, 4 * _s);
    }

    // tronco magro, de roupa queimada
    draw_set_color(_cloth);
    draw_triangle(_bx - 20 * _s, _y - 118 * _s, _bx + 20 * _s, _y - 118 * _s, _bx - 13 * _s, _y - 48 * _s, false);
    draw_triangle(_bx + 20 * _s, _y - 118 * _s, _bx - 13 * _s, _y - 48 * _s, _bx + 13 * _s, _y - 48 * _s, false);

    // pele aparecendo nos rasgos e manchas de queimadura
    draw_set_alpha(_a * 0.55);
    draw_set_color(_skin);
    draw_triangle(_bx - 9 * _s, _y - 110 * _s, _bx - 2 * _s, _y - 108 * _s, _bx - 6 * _s, _y - 84 * _s, false);
    draw_set_alpha(_a * 0.8);
    draw_set_color(_burn);
    draw_circle(_bx + 7 * _s, _y - 96 * _s, 5 * _s, false);
    draw_circle(_bx - 5 * _s, _y - 70 * _s, 4 * _s, false);
    draw_set_alpha(_a);

    // braços compridos e finos, com dedos tortos
    for (var sd = -1; sd <= 1; sd += 2) {
        var _shx = _bx + sd * 20 * _s;
        var _shy = _y - 114 * _s;
        var _elx = _bx + sd * (28 + 4 * _near) * _s;
        var _ely = _y - 70 * _s;
        var _wx  = _bx + sd * (24 + sin(_t * 0.06 + sd) * 5 + 10 * _near) * _s;
        var _wy  = _y - 26 * _s - 24 * _near * _s;
        scr_capsule(_shx, _shy, _elx, _ely, 6 * _s, _skin);
        scr_capsule(_elx, _ely, _wx, _wy, 5 * _s, _skin);
        draw_set_color(_skin);
        for (var f = 0; f < 4; f++) {
            var _fa = 255 + f * 10 + random_range(-4, 4);
            draw_line_width(_wx, _wy, _wx + lengthdir_x(15 * _s, _fa), _wy + lengthdir_y(15 * _s, _fa), 1.5 * _s);
        }
    }

    // pescoço torto e cabeça alongada
    var _hx = _bx + _lean;
    var _hy = _y - 130 * _s;
    scr_capsule(_bx, _y - 116 * _s, _hx, _hy + 8 * _s, 8 * _s, _skin);

    // cabelo comprido caindo
    draw_set_color(_soot);
    for (var h = 0; h < 8; h++) {
        var _hxx = _hx - 12 * _s + h * 3.4 * _s;
        draw_line_width(_hxx, _hy - 16 * _s, _hxx + sin(_t * 0.05 + h) * 3 * _s, _hy + (22 + (h mod 3) * 10) * _s, 3 * _s);
    }

    draw_set_color(_skin);
    draw_ellipse(_hx - 13 * _s, _hy - 19 * _s, _hx + 13 * _s, _hy + 21 * _s, false);

    // maçãs do rosto fundas
    draw_set_alpha(_a * 0.6);
    draw_set_color(make_color_rgb(70, 78, 90));
    draw_ellipse(_hx - 12 * _s, _hy + 2 * _s, _hx - 4 * _s, _hy + 14 * _s, false);
    draw_ellipse(_hx + 4 * _s, _hy + 2 * _s, _hx + 12 * _s, _hy + 14 * _s, false);
    draw_set_alpha(_a);

    // órbitas ocas
    draw_set_color(c_black);
    draw_ellipse(_hx - 10 * _s, _hy - 8 * _s, _hx - 2 * _s, _hy + 4 * _s, false);
    draw_ellipse(_hx + 2 * _s, _hy - 8 * _s, _hx + 10 * _s, _hy + 4 * _s, false);

    // boca: uma fenda que se escancara quando ele chega perto
    var _mo = (2 + 14 * _near) * _s;
    draw_ellipse(_hx - 5 * _s, _hy + 10 * _s, _hx + 5 * _s, _hy + 10 * _s + _mo, false);
    if (_near > 0.25) {
        draw_set_color(make_color_rgb(190, 180, 150));
        for (var tt = 0; tt < 4; tt++) {
            var _tx = _hx - 4.5 * _s + tt * 2.4 * _s;
            draw_triangle(_tx, _hy + 10 * _s, _tx + 2 * _s, _hy + 10 * _s, _tx + 1 * _s, _hy + 14 * _s, false);
        }
    }

    // rachaduras no rosto
    draw_set_color(_soot);
    draw_line_width(_hx - 3 * _s, _hy - 19 * _s, _hx - 6 * _s, _hy - 6 * _s, 1);
    draw_line_width(_hx + 6 * _s, _hy - 17 * _s, _hx + 3 * _s, _hy - 4 * _s, 1);

    // acessórios queimados (um por vítima do hotel)
    draw_set_color(make_color_rgb(54, 26, 26));
    switch (_style) {
        case 0:   // gravata
            draw_triangle(_bx - 3 * _s, _y - 114 * _s, _bx + 3 * _s, _y - 114 * _s, _bx, _y - 80 * _s, false);
        break;
        case 1:   // cartola
            draw_rectangle(_hx - 12 * _s, _hy - 44 * _s, _hx + 12 * _s, _hy - 20 * _s, false);
            draw_rectangle(_hx - 20 * _s, _hy - 22 * _s, _hx + 20 * _s, _hy - 18 * _s, false);
        break;
        case 2:   // óculos
            draw_circle(_hx - 6 * _s, _hy - 2 * _s, 6 * _s, true);
            draw_circle(_hx + 6 * _s, _hy - 2 * _s, 6 * _s, true);
        break;
        case 3:
        case 4:   // avental
            draw_rectangle(_bx - 11 * _s, _y - 100 * _s, _bx + 11 * _s, _y - 52 * _s, false);
        break;
        case 5:   // lenço na cabeça
            draw_triangle(_hx - 14 * _s, _hy - 14 * _s, _hx + 14 * _s, _hy - 14 * _s, _hx, _hy - 36 * _s, false);
        break;
        case 6:   // boné
            draw_rectangle(_hx - 13 * _s, _hy - 26 * _s, _hx + 13 * _s, _hy - 18 * _s, false);
            draw_rectangle(_hx, _hy - 20 * _s, _hx + 20 * _s, _hy - 17 * _s, false);
        break;
        default:  // quepe
            draw_rectangle(_hx - 14 * _s, _hy - 30 * _s, _hx + 14 * _s, _hy - 20 * _s, false);
            draw_rectangle(_hx - 17 * _s, _hy - 22 * _s, _hx + 17 * _s, _hy - 18 * _s, false);
        break;
    }

    // cinzas caindo do corpo
    draw_set_color(make_color_rgb(120, 120, 124));
    for (var p = 0; p < 5; p++) {
        var _pp = ((_t * 0.8 + p * 13 + _style * 5) mod 60) / 60;
        draw_set_alpha(_a * (1 - _pp) * 0.7);
        draw_circle(_bx + sin(p * 2.1 + _style) * 22 * _s, _y - 120 * _s + _pp * 110 * _s, 1.3 * _s, false);
    }

    draw_set_alpha(1);
}

// ---------- desenho: olhos acesos no escuro (chamar com blend aditivo) ----------
draw_ghost_eyes = function(_g) {
    if (_g.state != "active") return;

    var _dist  = point_distance(_g.x, _g.y, cx, cy);
    var _near  = clamp(1 - _dist / 240, 0, 1);
    var _s     = _g.scale;
    var _hx    = _g.x + 6 * _s * _near;
    var _hy    = _g.y - 132 * _s;
    var _pulse = 0.75 + 0.25 * sin(anim_t * 0.2 + _g.style);
    var _col   = merge_color(make_color_rgb(190, 225, 255), make_color_rgb(255, 30, 20), _near);

    for (var e = -1; e <= 1; e += 2) {
        var _ex = _hx + e * 6 * _s;
        draw_set_color(_col);
        draw_set_alpha(0.28 * _pulse);
        draw_circle(_ex, _hy, (7 + 8 * _near) * _s, false);
        draw_set_alpha(0.9 * _pulse);
        draw_circle(_ex, _hy, (1.6 + 1.6 * _near) * _s, false);
    }
    draw_set_alpha(1);
}

// ---------- desenho: todos os fantasmas, imagem dupla e anel de banimento ----------
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

        // imagem dupla quando está falhando
        if (_g.glitch > 0) {
            draw_ghost_figure(_g.x + random_range(-16, 16), _g.y + random_range(-3, 3), _g.scale, _g.style, _a * 0.35, _g);
        }
        draw_ghost_figure(_g.x, _g.y, _g.scale, _g.style, _a, _g);

        // anel dourado enchendo (quanto falta para banir)
        if (_g.state == "active" && _g.charge > 0) {
            var _gx = _g.x;
            var _gy = _g.y - 65 * _g.scale;
            var _rr = 40 * _g.scale;
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

    // os olhos brilham por cima de tudo, mesmo no escuro
    gpu_set_blendmode(bm_add);
    for (var j = 0; j < array_length(ghosts); j++) {
        draw_ghost_eyes(ghosts[j]);
    }
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
}

// ---------- desenho: estática / granulado (0 = só granulado, 1 = tela cheia) ----------
draw_static = function(_amount) {
    var _n = floor(40 + 260 * _amount);
    for (var i = 0; i < _n; i++) {
        draw_set_alpha(random_range(0.05, 0.35) * (0.4 + _amount));
        draw_set_color(choose(c_white, c_ltgray, c_gray));
        var _x = random(room_width);
        var _y = random(room_height);
        draw_rectangle(_x, _y, _x + random_range(2, 18), _y + random_range(1, 3), false);
    }
    if (_amount > 0.4) {
        repeat (2) {
            draw_set_alpha(0.2);
            draw_set_color(c_white);
            var _ty = random(room_height);
            draw_rectangle(0, _ty, room_width, _ty + random_range(2, 8), false);
        }
    }
    draw_set_alpha(1);
}

// ---------- desenho: vinheta que pulsa com o coração ----------
draw_horror_vignette = function() {
    var _p  = clamp(1 - min_dist / 260, 0, 1);              // 0 = seguro, 1 = perigo máximo
    var _a0 = 0.30 + 0.35 * _p + 0.25 * heart_pulse;
    draw_set_color(merge_color(c_black, make_color_rgb(120, 0, 0), _p));
    for (var k = 0; k < 8; k++) {
        draw_set_alpha(_a0 * (1 - k / 8) * 0.55);
        draw_rectangle(0, k * 10, room_width, k * 10 + 10, false);
        draw_rectangle(0, room_height - k * 10 - 10, room_width, room_height - k * 10, false);
        draw_rectangle(k * 10, 0, k * 10 + 10, room_height, false);
        draw_rectangle(room_width - k * 10 - 10, 0, room_width - k * 10, room_height, false);
    }
    draw_set_alpha(1);
}

// ---------- desenho: o rosto do jumpscare ----------
draw_scare_face = function(_x, _y, _s, _jaw) {
    // cabelo emaranhado
    draw_set_color(make_color_rgb(10, 10, 14));
    for (var i = 0; i < 16; i++) {
        var _hx0 = _x - 58 * _s + i * 7.5 * _s;
        draw_line_width(_hx0, _y - 74 * _s,
                        _hx0 - 10 * _s + sin(anim_t * 0.5 + i) * 6 * _s, _y + (20 + ((i * 13) mod 40)) * _s, 4.5 * _s);
    }

    // crânio alongado, pálido
    draw_set_color(make_color_rgb(208, 216, 222));
    draw_ellipse(_x - 42 * _s, _y - 62 * _s, _x + 42 * _s, _y + 60 * _s, false);

    // sombras: maçãs fundas e queixo
    draw_set_alpha(0.35);
    draw_set_color(c_black);
    draw_ellipse(_x - 38 * _s, _y + 2 * _s, _x - 12 * _s, _y + 34 * _s, false);
    draw_ellipse(_x + 12 * _s, _y + 2 * _s, _x + 38 * _s, _y + 34 * _s, false);
    draw_ellipse(_x - 42 * _s, _y + 30 * _s, _x + 42 * _s, _y + 60 * _s, false);
    draw_set_alpha(1);

    // pele queimada e rachaduras
    draw_set_color(make_color_rgb(34, 24, 20));
    draw_ellipse(_x - 30 * _s, _y - 54 * _s, _x - 8 * _s, _y - 36 * _s, false);
    draw_ellipse(_x + 14 * _s, _y - 8 * _s, _x + 34 * _s, _y + 8 * _s, false);
    draw_line_width(_x + 6 * _s, _y - 62 * _s, _x - 2 * _s, _y - 30 * _s, 2 * _s);
    draw_line_width(_x - 2 * _s, _y - 30 * _s, _x + 8 * _s, _y - 14 * _s, 1.5 * _s);
    draw_line_width(_x - 26 * _s, _y + 6 * _s, _x - 36 * _s, _y + 30 * _s, 1.5 * _s);

    // veias vermelhas saindo dos olhos
    draw_set_color(make_color_rgb(120, 10, 10));
    for (var v = 0; v < 6; v++) {
        draw_line_width(_x - 18 * _s, _y - 12 * _s, _x - 18 * _s + (v - 3) * 9 * _s, _y - 36 * _s - (v mod 2) * 8 * _s, 1.2 * _s);
        draw_line_width(_x + 18 * _s, _y - 12 * _s, _x + 18 * _s + (v - 3) * 9 * _s, _y - 36 * _s - (v mod 2) * 8 * _s, 1.2 * _s);
    }

    // órbitas fundas
    draw_set_color(c_black);
    draw_ellipse(_x - 31 * _s, _y - 30 * _s, _x - 7 * _s, _y + 6 * _s, false);
    draw_ellipse(_x + 7 * _s, _y - 30 * _s, _x + 31 * _s, _y + 6 * _s, false);

    // pupilas em brasa (piscam)
    var _pw = 0.6 + 0.4 * sin(anim_t * 0.9);
    gpu_set_blendmode(bm_add);
    draw_set_color(make_color_rgb(255, 40, 30));
    draw_set_alpha(0.35 * _pw);
    draw_circle(_x - 19 * _s, _y - 12 * _s, 16 * _s, false);
    draw_circle(_x + 19 * _s, _y - 12 * _s, 16 * _s, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_circle(_x - 19 * _s, _y - 12 * _s, 3 * _s, false);
    draw_circle(_x + 19 * _s, _y - 12 * _s, 3 * _s, false);
    gpu_set_blendmode(bm_normal);

    // nariz: duas fendas
    draw_set_color(c_black);
    draw_triangle(_x - 6 * _s, _y + 12 * _s, _x - 2 * _s, _y + 12 * _s, _x - 4 * _s, _y + 22 * _s, false);
    draw_triangle(_x + 2 * _s, _y + 12 * _s, _x + 6 * _s, _y + 12 * _s, _x + 4 * _s, _y + 22 * _s, false);

    // mandíbula que estala sem parar
    var _mo = (14 + 42 * _jaw) * _s;
    draw_ellipse(_x - 22 * _s, _y + 26 * _s, _x + 22 * _s, _y + 26 * _s + _mo, false);
    draw_set_color(make_color_rgb(196, 186, 150));
    for (var t1 = 0; t1 < 8; t1++) {
        var _tx = _x - 20 * _s + t1 * 5.7 * _s;
        draw_triangle(_tx, _y + 26 * _s, _tx + 5 * _s, _y + 26 * _s, _tx + 2.5 * _s, _y + (35 + (t1 mod 3) * 3) * _s, false);
        draw_triangle(_tx, _y + 26 * _s + _mo, _tx + 5 * _s, _y + 26 * _s + _mo, _tx + 2.5 * _s, _y + 26 * _s + _mo - (8 + (t1 mod 2) * 4) * _s, false);
    }

    // baba escura entre os dentes
    draw_set_color(make_color_rgb(40, 8, 8));
    draw_line_width(_x - 8 * _s, _y + 34 * _s, _x - 8 * _s, _y + 26 * _s + _mo - 8 * _s, 1.5 * _s);
    draw_line_width(_x + 6 * _s, _y + 34 * _s, _x + 6 * _s, _y + 26 * _s + _mo - 8 * _s, 1.5 * _s);

    // aberração cromática (contornos vermelho e ciano deslocados)
    gpu_set_blendmode(bm_add);
    draw_set_alpha(0.5);
    draw_set_color(make_color_rgb(255, 20, 20));
    draw_ellipse(_x - 42 * _s - 7, _y - 62 * _s, _x + 42 * _s - 7, _y + 60 * _s, true);
    draw_set_color(make_color_rgb(20, 220, 255));
    draw_ellipse(_x - 42 * _s + 7, _y - 62 * _s, _x + 42 * _s + 7, _y + 60 * _s, true);
    gpu_set_blendmode(bm_normal);
    draw_set_alpha(1);
}

// ---------- desenho: mãos garrudas agarrando a tela (susto fatal) ----------
draw_scare_hands = function() {
    for (var sd = -1; sd <= 1; sd += 2) {
        var _hx0 = room_width / 2 + sd * (room_width / 2 + 10);
        var _hx1 = room_width / 2 + sd * (150 + random_range(0, 14));
        var _hy1 = room_height / 2 + 100 + random_range(-8, 8);
        scr_capsule(_hx0, _hy1 + 120, _hx1, _hy1, 28, make_color_rgb(150, 160, 170));
        for (var f = 0; f < 5; f++) {
            var _fa = ((sd == -1) ? 0 : 180) + (f - 2) * 18 + random_range(-4, 4);
            var _ex = _hx1 + lengthdir_x(76, _fa);
            var _ey = _hy1 + lengthdir_y(76, _fa);
            draw_set_color(make_color_rgb(150, 160, 170));
            draw_line_width(_hx1, _hy1, _ex, _ey, 10);
            draw_set_color(make_color_rgb(30, 22, 18));
            draw_circle(_ex, _ey, 6, false);
        }
    }
}
