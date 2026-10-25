event_inherited();
vanish_t = -1;
// puzzle já resolvido antes? então o painel nem existe mais
if (scr_flag("negocios_3_unlocked")) { instance_destroy(); exit; }
// ---------- tamanho do painel (e da área clicável) ----------
panel_w = 432;
panel_h = 288;
image_xscale = panel_w / sprite_get_width(sprite_index);
image_yscale = panel_h / sprite_get_height(sprite_index);

// o texto é trocado conforme o progresso, no Left Pressed
dialog_lines = ["Um painel de controle da porta."];

// ---------- encaixes das engrenagens ----------
// lx/ly = centro do encaixe, relativo ao canto superior esquerdo do painel
// r     = raio da engrenagem; dir = sentido de giro (engrenagens
//         vizinhas giram em sentidos opostos)
// item  = nome EXATO do item no inventário
// spr   = nome do sprite (texto) usado só para desenhar
gear_slots = [
    { item: "Engrenagem Grande",  spr: "spr_gear_large",  lx: 80,  ly: 208, r: 48, flag: "gear_large_placed",  dir:  1, angle: 0 },
    { item: "Engrenagem Média",   spr: "spr_gear_medium", lx: 146, ly: 162, r: 32, flag: "gear_medium_placed", dir: -1, angle: 0 },
    { item: "Engrenagem Pequena", spr: "spr_gear_small",  lx: 172, ly: 117, r: 20, flag: "gear_small_placed",  dir:  1, angle: 0 }
];

// ---------- fios ----------
// bow = o quanto o fio "cai" no meio. O fio vermelho (bow 26) e o amarelo
// (bow -18) se encontram no meio: é o curto-circuito.
// bow_fixed = como o fio fica depois de cortado/aliviado.
build_wire_pts = function(_base_y, _bow) {
    var _pts = [];
    for (var i = 0; i <= 16; i++) {
        var _t = i / 16;
        array_push(_pts, [lerp(244, 404, _t), _base_y + _bow * sin(pi * _t)]);
    }
    return _pts;
}

wires = [
    { col: make_color_rgb(50, 110, 220), base_y: 96,  bow: 0,   bow_fixed: 0, shorted: false, pts: [] },
    { col: make_color_rgb(210, 40, 40),  base_y: 140, bow: 26,  bow_fixed: 6, shorted: true,  pts: [] },
    { col: make_color_rgb(235, 200, 50), base_y: 184, bow: -18, bow_fixed: 0, shorted: false, pts: [] },
    { col: make_color_rgb(50, 170, 80),  base_y: 228, bow: 0,   bow_fixed: 0, shorted: false, pts: [] }
];

// monta (ou remonta) o desenho dos fios de acordo com a flag
apply_wiring_state = function() {
    var _fixed = scr_flag("wiring_fixed");
    for (var i = 0; i < array_length(wires); i++) {
        var _b = _fixed ? wires[i].bow_fixed : wires[i].bow;
        wires[i].pts = build_wire_pts(wires[i].base_y, _b);
    }
}
apply_wiring_state();

// distância do clique (coord. do painel) até um fio
wire_distance = function(_i, _mx, _my) {
    var _pts = wires[_i].pts;
    var _min = 999999;
    for (var s = 0; s < array_length(_pts) - 1; s++) {
        var _d = scr_point_seg_dist(_mx, _my, _pts[s][0], _pts[s][1], _pts[s + 1][0], _pts[s + 1][1]);
        _min = min(_min, _d);
    }
    return _min;
}

// verifica se o puzzle terminou; devolve falas extras para o diálogo
check_solved = function() {
    var _msgs = [];

    if (!scr_flag("gear_panel_solved")) {
        var _all = true;
        for (var i = 0; i < array_length(gear_slots); i++) {
            if (!scr_flag(gear_slots[i].flag)) _all = false;
        }
        if (_all) {
            scr_flag_set("gear_panel_solved");
            array_push(_msgs, "Essa era a última engrenagem. O mecanismo está completo.");
        }
    }

    if (scr_flag("gear_panel_solved") && scr_flag("wiring_fixed") && !scr_flag("negocios_3_unlocked")) {
        scr_flag_set("negocios_3_unlocked");
        array_push(_msgs, "O painel ganhou vida e ouvi um clique vindo da porta. Está destravada.");
    }

    return _msgs;
}

// ---------- visual ----------
draw_recess = function(_x1, _y1, _x2, _y2, _c_top, _c_bot) {
    draw_rectangle_color(_x1, _y1, _x2, _y2, _c_top, _c_top, _c_bot, _c_bot, false);
    // chanfro de baixo-relevo: sombra em cima/esquerda, brilho embaixo/direita
    draw_set_color(make_color_rgb(232, 206, 130));
    draw_line_width(_x1, _y2, _x2, _y2, 2);
    draw_line_width(_x2, _y1, _x2, _y2, 2);
    draw_set_color(make_color_rgb(40, 28, 10));
    draw_line_width(_x1, _y1, _x2, _y1, 2);
    draw_line_width(_x1, _y1, _x1, _y2, 2);
}

draw_led = function(_x, _y, _on) {
    var _blink = ((current_time div 450) mod 2) == 0;
    var _c1, _c2;
    if (_on) {
        _c1 = make_color_rgb(150, 255, 160);
        _c2 = make_color_rgb(20, 150, 50);
    }
    else if (_blink) {
        _c1 = make_color_rgb(255, 120, 110);
        _c2 = make_color_rgb(170, 20, 20);
    }
    else {
        _c1 = make_color_rgb(110, 40, 38);
        _c2 = make_color_rgb(60, 14, 14);
    }
    draw_set_color(c_black);
    draw_circle(_x, _y, 7, false);
    draw_circle_color(_x, _y, 5, _c1, _c2, false);
}
// margens de clique (aumente se ainda estiver difícil acertar)
gear_click_margin = 40;   // pixels além da borda do encaixe
wire_click_margin = 24;   // pixels de distância do fio

// garante que cada item ainda não coletado exista na sala
var _items = [
    [obj_pickup_gear_large,  "gear_large_taken"],
    [obj_pickup_gear_medium, "gear_medium_taken"],
    [obj_pickup_gear_small,  "gear_small_taken"],
    [obj_pickup_pliers,      "pliers_taken"]
];
for (var i = 0; i < array_length(_items); i++) {
    if (!scr_flag(_items[i][1]) && !instance_exists(_items[i][0])) {
        instance_create_layer(0, 0, layer, _items[i][0]);
    }
}
panel_revealed = scr_flag("gear_panel_revealed");   // já foi descoberto antes?
panel_open     = false;   // tampa fechada
door_t         = 0;       // 0 = tampa fechada, 1 = aberta (anima entre os dois)
reveal_t       = 0;       // clarão da revelação
reveal_dwell   = 0;       // frames com a luz em cima do painel
reveal_frames  = 15;      // quantos frames a luz precisa ficar em cima para revelar