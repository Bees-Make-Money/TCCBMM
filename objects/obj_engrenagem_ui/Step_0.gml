angulo -= 1.5;
if (angulo <= -360) angulo += 360;

mouse_xx = device_mouse_x_to_gui(0);
mouse_yy = device_mouse_y_to_gui(0);

// --- PROCESSAMENTO DO SISTEMA I (ENGRENAGENS) ---
c_trav = true;
f_trav = true;

for(var i=0; i<array_length(conexoes_eng); i++) {
    var p = conexoes_eng[i];
    if ((p[0] == "H" && p[1] == "C") || (p[0] == "C" && p[1] == "H")) c_trav = false;
    if ((p[0] == "I" && p[1] == "F") || (p[0] == "F" && p[1] == "I")) f_trav = false;
}

var cadeia = ["A", "B", "C", "D", "E", "F", "G", "OUT"];
var seq_ok = true;
for(var i=0; i<array_length(cadeia)-1; i++) {
    var achou = false;
    for(var c=0; c<array_length(conexoes_eng); c++) {
        var p = conexoes_eng[c];
        if ((p[0] == cadeia[i] && p[1] == cadeia[i+1]) || (p[0] == cadeia[i+1] && p[1] == cadeia[i])) {
            achou = true; break;
        }
    }
    if (!achou) { seq_ok = false; break; }
}
if (c_trav || f_trav) seq_ok = false;
eng_resolvido = seq_ok;

// --- PROCESSAMENTO DO SISTEMA II (ELÉTRICO) ---
var gabarito = [
    ["BAT-A","D1"], ["BAT-B","R1"], ["BAT-C","C1"], ["BAT-D","R2"],
    ["D1","J1"], ["R1","J1"], ["C1","J2"], ["R2","J2"],
    ["J1","Q1"], ["J2","Q2"], ["Q1","J3"], ["Q2","J3"],
    ["J3","F1"], ["F1","K1"], ["K1","OUT"], ["GND-1","J2"], ["GND-2","K1"]
];

curto_circuito = false;
var gnd1_ok = false;
var gnd2_ok = false;

for(var i=0; i<array_length(conexoes_ele); i++) {
    var p = conexoes_ele[i];
    if (string_pos("BAT", p[0]) > 0 && (p[1] == "J3" || p[1] == "OUT")) curto_circuito = true;
    if (string_pos("BAT", p[1]) > 0 && (p[0] == "J3" || p[0] == "OUT")) curto_circuito = true;
    
    if ((p[0] == "GND-1" && p[1] == "J2") || (p[1] == "GND-1" && p[0] == "J2")) gnd1_ok = true;
    if ((p[0] == "GND-2" && p[1] == "K1") || (p[1] == "GND-2" && p[0] == "K1")) gnd2_ok = true;
}

if (curto_circuito) {
    conexoes_ele = [];
    fusivel_queimado = false;
}

var t_j1 = 0; var t_j2 = 0; var acertos = 0;
for(var i=0; i<array_length(conexoes_ele); i++) {
    var p = conexoes_ele[i];
    for(var g=0; g<array_length(gabarito); g++) {
        var gb = gabarito[g];
        if ((p[0] == gb[0] && p[1] == gb[1]) || (p[0] == gb[1] && p[1] == gb[0])) {
            acertos++;
            if (p[0] == "BAT-A" || p[1] == "BAT-A") t_j1 += 6;
            if (p[0] == "BAT-B" || p[1] == "BAT-B") t_j1 += 4;
            if (p[0] == "BAT-C" || p[1] == "BAT-C") t_j2 += 3;
            if (p[0] == "BAT-D" || p[1] == "BAT-D") t_j2 += 2;
        }
    }
}

var v_j3 = 0;
if (gnd1_ok) v_j3 += (t_j1 + t_j2);

if (v_j3 > 15) fusivel_queimado = true;

if (acertos == 17 && !fusivel_queimado && gnd1_ok && gnd2_ok) {
    tensao_out = 15;
    ele_resolvido = true;
} else {
    ele_resolvido = false;
    tensao_out = fusivel_queimado ? 0 : v_j3;
}

for(var i=0; i<array_length(conexoes_eng); i++) {
    var p = conexoes_eng[i];
    if ((p[0] == "H" && p[1] == "C") || (p[0] == "C" && p[1] == "H")) c_trav = false;
    if ((p[0] == "I" && p[1] == "F") || (p[0] == "F" && p[1] == "I")) f_trav = false;
}


if (ele_resolvido == true && eng_resolvido == true) {
    puzzle_concluido = true; // Trava ativada
    room_goto(rm_sala_negocios2);
}
