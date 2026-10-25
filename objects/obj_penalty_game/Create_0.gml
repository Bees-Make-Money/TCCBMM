// o scr_show_dialog precisa desta layer, e a rm_penaltis é uma room nova
if (!layer_exists("Text_Dialogs")) layer_create(-200, "Text_Dialogs");

gx1 = 278;  gx2 = 538;            // postes
gy1 = 210;  gy2 = 330;            // travessão e linha do gol
goal_cx = (gx1 + gx2) / 2;
spot_x = 408;  spot_y = 478;      // marca do pênalti
player_x = 352;  player_y = 552;  // pés do batedor

// ---------- regras ----------
goals_needed  = 3;     // gols para ser liberto
max_misses    = 3;     // errar 3 = "mais do que duas" = morte
mystery_digit = 7;     // dígito do papel (troque quando quiser)

// ---------- dificuldade ----------
aim_speed_x  = 0.045;  // velocidade da mira na horizontal (maior = mais rápido)
aim_speed_y  = 0.060;  // velocidade da mira na vertical
keeper_reach = 26;     // alcance do goleiro, em pixels
shot_frames  = 36;     // duração do chute, em frames

// ---------- estado ----------
st = "intro";          // intro, aim_x, aim_y, shoot, result, win, lose, dead
goals  = 0;
misses = 0;
results = [];          // "gol" ou "erro" por tentativa
aim_t  = random(2 * pi);
aim_x  = goal_cx;
aim_y  = (gy1 + gy2) / 2;
lock_x = goal_cx;

shot_t = 0;  shot_tx = 0;  shot_ty = 0;
shot_result = "";  shot_text = "";
result_timer = 0;  end_timer = 0;  win_stage = 0;
anim_t = 0;

ball_x = spot_x;  ball_y = spot_y;  ball_r = 9;
kick_t = 0;

keeper_x = goal_cx;  keeper_y = gy2;  keeper_angle = 0;  keeper_arm = 0.2;
keeper_side = 0;  keeper_hand_x = goal_cx;  keeper_hand_y = gy1 + 50;  keeper_e = 0;

// os 5 cantos para onde o goleiro pode mergulhar
dive_targets = [
    { side: -1, x: gx1 + 42, y: gy2 - 22 },   // esquerda, baixo
    { side: -1, x: gx1 + 46, y: gy1 + 34 },   // esquerda, alto
    { side:  0, x: goal_cx,  y: gy1 + 90 },   // centro
    { side:  1, x: gx2 - 46, y: gy1 + 34 },   // direita, alto
    { side:  1, x: gx2 - 42, y: gy2 - 22 }    // direita, baixo
];
keeper_end_x = goal_cx;
keeper_end_y = gy2;

// torcida (gerada uma vez)
crowd = [];
var _cc = [make_color_rgb(200, 40, 40), make_color_rgb(230, 200, 60), make_color_rgb(60, 120, 200),
           make_color_rgb(240, 240, 240), make_color_rgb(40, 160, 80)];
for (var i = 0; i < 260; i++) {
    array_push(crowd, { cx: random(room_width), cy: random_range(96, 200), col: _cc[irandom(4)], ph: random(6.28) });
}

// ---------- lógica ----------
start_attempt = function() {
    st = "aim_x";
    aim_t = random(2 * pi);
    ball_x = spot_x;
    ball_y = spot_y;
    ball_r = 9;
    kick_t = 0;
    keeper_e = 0;
    shot_result = "";
}

fire = function() {
    shot_tx = aim_x;
    shot_ty = aim_y;
    shot_t  = 0;
    st = "shoot";

    // o goleiro escolhe um canto
    var _d = dive_targets[irandom(array_length(dive_targets) - 1)];
    keeper_side   = _d.side;
    keeper_hand_x = _d.x;
    keeper_hand_y = _d.y;

    // pose FINAL do mergulho (a animação do Step usa exatamente esta)
    keeper_end_x = keeper_hand_x - keeper_side * 115.6;
    keeper_end_y = min(gy2, keeper_hand_y + 31);

    // onde ficam as mãos, a cabeça e o tronco nessa pose
    var _ox = keeper_x;
    var _oy = keeper_y;
    var _oa = keeper_angle;
    keeper_x = keeper_end_x;
    keeper_y = keeper_end_y;
    keeper_angle = -keeper_side * 75;
    var _body = [keeper_pt(-10, -126), keeper_pt(10, -126), keeper_pt(0, -88), keeper_pt(0, -60), keeper_pt(0, -34)];
    keeper_x = _ox;
    keeper_y = _oy;
    keeper_angle = _oa;

    var _inside = (shot_tx > gx1 + 5 && shot_tx < gx2 - 5 && shot_ty > gy1 + 5 && shot_ty < gy2);
    var _post   = (abs(shot_tx - gx1) <= 5 || abs(shot_tx - gx2) <= 5) && shot_ty > gy1 - 5 && shot_ty <= gy2;
    var _bar    = abs(shot_ty - gy1) <= 5 && shot_tx > gx1 - 5 && shot_tx < gx2 + 5;

    var _saved = false;
    for (var b = 0; b < array_length(_body); b++) {
        if (point_distance(shot_tx, shot_ty, _body[b][0], _body[b][1]) <= keeper_reach) _saved = true;
    }

    if (_post || _bar)  shot_result = "trave";
    else if (!_inside)  shot_result = "fora";
    else if (_saved)    shot_result = "defendeu";
    else                shot_result = "gol";
}

finish_shot = function() {
    if (shot_result == "gol") {
        goals++;
        array_push(results, "gol");
        shot_text = "GOOOL!";
    }
    else {
        misses++;
        array_push(results, "erro");
        if (shot_result == "defendeu")  shot_text = "DEFENDEU!";
        else if (shot_result == "trave") shot_text = "NA TRAVE!";
        else                             shot_text = "PRA FORA!";
    }
    st = "result";
    result_timer = 80;
}

// ---------- desenho ----------
// converte coordenadas locais do goleiro (pés = 0,0; y negativo = para cima)
keeper_pt = function(_lx, _ly) {
    var _sc = 0.95;
    var _sx = _lx * _sc;
    var _sy = _ly * _sc;
    var _a  = keeper_angle;
    return [keeper_x + _sx * dcos(_a) + _sy * dsin(_a),
            keeper_y - _sx * dsin(_a) + _sy * dcos(_a)];
}

draw_stadium = function() {
    // céu / fundo
    draw_rectangle_color(0, 0, room_width, 150,
        make_color_rgb(8, 12, 40), make_color_rgb(8, 12, 40),
        make_color_rgb(40, 52, 110), make_color_rgb(40, 52, 110), false);

    // arquibancada
    draw_set_color(make_color_rgb(34, 36, 48));
    draw_rectangle(0, 90, room_width, 215, false);

    // torcida (pula quando é gol)
    var _amp = (st == "result" && shot_result == "gol") ? 5 : 1.5;
    for (var i = 0; i < array_length(crowd); i++) {
        var _c = crowd[i];
        var _bob = sin((anim_t * 0.08) + _c.ph) * _amp;
        draw_set_color(_c.col);
        draw_circle(_c.cx, _c.cy + _bob, 3, false);
    }

    // placas de publicidade
    draw_set_color(make_color_rgb(20, 70, 140));
    draw_rectangle(0, 214, room_width, 236, false);
    draw_set_color(make_color_rgb(230, 200, 60));
    for (var p = 0; p < 12; p++) {
        draw_rectangle(20 + p * 68, 220, 52 + p * 68, 230, false);
    }

    // gramado com faixas
    for (var s = 0; s < 8; s++) {
        draw_set_color((s mod 2 == 0) ? make_color_rgb(34, 120, 52) : make_color_rgb(40, 138, 60));
        draw_rectangle(0, 236 + s * 49, room_width, 236 + (s + 1) * 49, false);
    }

    // linhas do campo
    draw_set_color(c_white);
    draw_line_width(120, gy2, 696, gy2, 3);             // linha de fundo
    draw_line_width(150, gy2, 96, 560, 3);              // grande área, esquerda
    draw_line_width(666, gy2, 720, 560, 3);             // grande área, direita
    draw_line_width(96, 560, 720, 560, 3);              // grande área, frente
    draw_line_width(gx1 - 30, gy2, gx1 - 50, 385, 3);   // pequena área
    draw_line_width(gx2 + 30, gy2, gx2 + 50, 385, 3);
    draw_line_width(gx1 - 50, 385, gx2 + 50, 385, 3);

    // marca do pênalti
    draw_ellipse(spot_x - 5, spot_y - 2, spot_x + 5, spot_y + 2, false);
}

draw_goal_net = function() {
    draw_set_alpha(0.35);
    draw_set_color(c_white);
    for (var xx = gx1; xx <= gx2; xx += 12) draw_line(xx, gy1, xx, gy2);
    for (var yy = gy1; yy <= gy2; yy += 12) draw_line(gx1, yy, gx2, yy);
    draw_set_alpha(1);
}

draw_goal_posts = function() {
    draw_set_color(c_white);
    draw_line_width(gx1, gy2, gx1, gy1, 7);
    draw_line_width(gx2, gy2, gx2, gy1, 7);
    draw_line_width(gx1 - 3, gy1, gx2 + 3, gy1, 7);
}

draw_ball_at = function(_x, _y, _r) {
    // sombra no chão enquanto a bola está parada
    if (st != "shoot" && st != "result") {
        draw_set_alpha(0.3);
        draw_set_color(c_black);
        draw_ellipse(_x - _r, _y + _r * 0.6, _x + _r, _y + _r * 1.3, false);
        draw_set_alpha(1);
    }
    draw_set_color(c_white);
    draw_circle(_x, _y, _r, false);
    draw_set_color(make_color_rgb(30, 30, 30));
    draw_circle(_x, _y, _r, true);
    draw_circle(_x, _y, _r * 0.35, false);
    for (var i = 0; i < 5; i++) {
        var _a = 90 + i * 72;
        draw_circle(_x + lengthdir_x(_r * 0.8, _a), _y + lengthdir_y(_r * 0.8, _a), _r * 0.18, false);
    }
}

// goleiro com uniforme azul (estilo seleção italiana de 94)
draw_keeper_figure = function() {
    var _blue  = make_color_rgb(18, 84, 168);
    var _skin  = make_color_rgb(226, 178, 140);
    var _w     = 0.95;

    // chuteiras
    var _f1 = keeper_pt(-9, -3);
    var _f2 = keeper_pt(9, -3);
    draw_set_color(c_black);
    draw_circle(_f1[0], _f1[1], 5 * _w, false);
    draw_circle(_f2[0], _f2[1], 5 * _w, false);

    // meiões azuis
    var _h1 = keeper_pt(-5, -46);
    var _h2 = keeper_pt(5, -46);
    scr_capsule(_h1[0], _h1[1], _f1[0], _f1[1], 8 * _w, _blue);
    scr_capsule(_h2[0], _h2[1], _f2[0], _f2[1], 8 * _w, _blue);

    // calção branco
    var _k1 = keeper_pt(-5, -32);
    var _k2 = keeper_pt(5, -32);
    scr_capsule(_h1[0], _h1[1], _k1[0], _k1[1], 12 * _w, c_white);
    scr_capsule(_h2[0], _h2[1], _k2[0], _k2[1], 12 * _w, c_white);

    // camisa azul
    var _t1 = keeper_pt(0, -48);
    var _t2 = keeper_pt(0, -78);
    scr_capsule(_t1[0], _t1[1], _t2[0], _t2[1], 30 * _w, _blue);

    // braços (sobem no mergulho) com luvas brancas
    for (var sd = -1; sd <= 1; sd += 2) {
        var _sh = keeper_pt(sd * 14, -78);
        var _hx = sd * lerp(23, 10, keeper_arm);
        var _hy = lerp(-52, -126, keeper_arm);
        var _ha = keeper_pt(_hx, _hy);
        scr_capsule(_sh[0], _sh[1], _ha[0], _ha[1], 9 * _w, _blue);
        draw_set_color(c_white);
        draw_circle(_ha[0], _ha[1], 6 * _w, false);
    }

    // gola e escudo
    var _col = keeper_pt(0, -80);
    draw_set_color(c_white);
    draw_circle(_col[0], _col[1], 5 * _w, false);
    var _bd = keeper_pt(-8, -68);
    draw_circle(_bd[0], _bd[1], 3 * _w, false);

    // cabeça (cabelo escuro + rosto)
    var _hd = keeper_pt(0, -94);
    draw_set_color(make_color_rgb(40, 28, 20));
    draw_circle(_hd[0], _hd[1] - 1.5, 9.5 * _w, false);
    draw_set_color(_skin);
    var _fc = keeper_pt(0, -91);
    draw_circle(_fc[0], _fc[1], 8 * _w, false);
}

// batedor de costas, uniforme verde e amarelo
draw_player_figure = function() {
    var _px = player_x;
    var _py = player_y;
    var _sc = 1.15;
    var _yellow = make_color_rgb(250, 214, 20);
    var _green  = make_color_rgb(10, 130, 56);
    var _k = kick_t;

    // chuteiras
    draw_set_color(c_black);
    draw_circle(_px - 8 * _sc, _py - 2 * _sc, 5 * _sc, false);
    var _fx = _px + (7 + 14 * _k) * _sc;
    var _fy = _py - (2 + 34 * _k) * _sc;
    draw_circle(_fx, _fy, 5 * _sc, false);

    // meiões amarelos
    scr_capsule(_px - 6 * _sc, _py - 46 * _sc, _px - 8 * _sc, _py - 2 * _sc, 8 * _sc, _yellow);
    scr_capsule(_px + 6 * _sc, _py - 46 * _sc, _fx, _fy, 8 * _sc, _yellow);

    // calção verde
    scr_capsule(_px - 6 * _sc, _py - 46 * _sc, _px - 7 * _sc, _py - 32 * _sc, 12 * _sc, _green);
    scr_capsule(_px + 6 * _sc, _py - 46 * _sc, _px + 7 * _sc, _py - 32 * _sc, 12 * _sc, _green);

    // camisa amarela
    scr_capsule(_px, _py - 48 * _sc, _px, _py - 78 * _sc, 30 * _sc, _yellow);

    // braços
    scr_capsule(_px - 14 * _sc, _py - 78 * _sc, _px - 22 * _sc, _py - 54 * _sc, 8 * _sc, _yellow);
    scr_capsule(_px + 14 * _sc, _py - 78 * _sc, _px + 22 * _sc, _py - 54 * _sc, 8 * _sc, _yellow);

    // gola verde e número 10 nas costas
    draw_set_color(_green);
    draw_circle(_px, _py - 80 * _sc, 6 * _sc, false);
    draw_set_font(fnt_testes);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(_px, _py - 64 * _sc, "10", 0.6, 0.6, 0);

    // cabeça (de costas: só cabelo)
    draw_set_color(make_color_rgb(40, 28, 20));
    draw_circle(_px, _py - 92 * _sc, 9 * _sc, false);
}

draw_aim = function() {
    if (st != "aim_x" && st != "aim_y") return;

    // guia da varredura
    var _half = (gx2 - gx1) / 2 + 40;
    draw_set_alpha(0.25);
    draw_set_color(c_yellow);
    if (st == "aim_x") {
        draw_line_width(goal_cx - _half, aim_y, goal_cx + _half, aim_y, 2);
    }
    else {
        draw_line_width(lock_x, gy1 - 34, lock_x, gy2 - 4, 2);
    }
    draw_set_alpha(1);

    // direção já travada
    if (st == "aim_y") {
        draw_set_color(c_lime);
        draw_line_width(lock_x, gy1 - 40, lock_x, gy2 + 6, 2);
    }

    // mira
    draw_set_color(c_red);
    draw_circle(aim_x, aim_y, 12, true);
    draw_circle(aim_x, aim_y, 11, true);
    draw_line_width(aim_x - 18, aim_y, aim_x + 18, aim_y, 2);
    draw_line_width(aim_x, aim_y - 18, aim_x, aim_y + 18, 2);
}

draw_hud = function() {
    draw_set_font(fnt_testes);

    // painel do placar
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_roundrect_ext(room_width / 2 - 150, 14, room_width / 2 + 150, 84, 12, 12, false);
    draw_set_alpha(1);

    // 5 tentativas
    for (var i = 0; i < 5; i++) {
        var _cx = room_width / 2 - 80 + i * 40;
        var _cy = 36;
        draw_set_color(make_color_rgb(70, 70, 80));
        draw_circle(_cx, _cy, 13, false);
        if (i < array_length(results)) {
            if (results[i] == "gol") {
                draw_set_color(make_color_rgb(60, 200, 90));
                draw_circle(_cx, _cy, 11, false);
            }
            else {
                draw_set_color(make_color_rgb(210, 50, 50));
                draw_circle(_cx, _cy, 11, false);
                draw_set_color(c_white);
                draw_line_width(_cx - 6, _cy - 6, _cx + 6, _cy + 6, 3);
                draw_line_width(_cx - 6, _cy + 6, _cx + 6, _cy - 6, 3);
            }
        }
    }

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text_transformed(room_width / 2, 68, "Gols " + string(goals) + "/" + string(goals_needed) + "     Erros " + string(misses) + "/" + string(max_misses), 0.7, 0.7, 0);

    // instrução
    var _msg = "";
    if (st == "aim_x")      _msg = "Clique para travar a DIREÇÃO do chute";
    else if (st == "aim_y") _msg = "Clique para travar a ALTURA e chutar";
    if (_msg != "") {
        draw_set_alpha(0.7);
        draw_set_color(c_black);
        draw_roundrect_ext(room_width / 2 - 230, room_height - 52, room_width / 2 + 230, room_height - 14, 10, 10, false);
        draw_set_alpha(1);
        draw_set_color(c_white);
        draw_text_transformed(room_width / 2, room_height - 33, _msg, 0.8, 0.8, 0);
    }

    // resultado do chute
    if (st == "result" || st == "win" || st == "lose" || st == "dead") {
        draw_set_color(c_black);
        draw_text_transformed(room_width / 2 + 3, 153, shot_text, 3, 3, 0);
        draw_set_color((shot_result == "gol") ? c_yellow : c_red);
        draw_text_transformed(room_width / 2, 150, shot_text, 3, 3, 0);
    }

    // tela inicial
    if (st == "intro") {
        draw_set_alpha(0.8);
        draw_set_color(c_black);
        draw_rectangle(0, 0, room_width, room_height, false);
        draw_set_alpha(1);
        draw_set_color(c_yellow);
        draw_text_transformed(room_width / 2, 210, "PÊNALTIS", 3, 3, 0);
        draw_set_color(c_white);
        draw_text_transformed(room_width / 2, 290, "Faça " + string(goals_needed) + " gols em 5 tentativas.", 1.2, 1.2, 0);
        draw_text_transformed(room_width / 2, 330, "Errou " + string(max_misses) + " vezes... acabou.", 1.2, 1.2, 0);
        draw_text_transformed(room_width / 2, 410, "Clique para começar", 1, 1, 0);
    }
}
