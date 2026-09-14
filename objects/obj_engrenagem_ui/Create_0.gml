// ═══════════════════════════════════════════════════════════════
// CREATE EVENT - Configuração de Proporção e Dados do Puzzle
// ═══════════════════════════════════════════════════════════════
w = 816;
h = 624;

// Paleta Industrial Elegante
c_fundo      = make_color_rgb(14, 10, 6);
c_painel     = make_color_rgb(22, 16, 10);
c_borda      = make_color_rgb(120, 95, 60);
c_ouro       = make_color_rgb(212, 162, 78);
c_verde      = make_color_rgb(60, 180, 90);
c_verm       = make_color_rgb(190, 50, 50);
c_metal      = make_color_rgb(140, 145, 150);
c_metal_esc  = make_color_rgb(45, 48, 52);

// Controle Geral de Interface
aba = 0; // 0 = Transmissão Mecânica, 1 = Circuito Elétrico
arrastando = false;
arr_from = "";
mouse_xx = 0;
mouse_yy = 0;

// ==========================================
// SISTEMA I: ENGRENAGENS (Layout Centrado)
// ==========================================
c_trav = true;
f_trav = true;
eng_resolvido = false;
angulo = 0;
conexoes_eng = [];

// Lista de Engrenagens conforme o Manual
engrenagens = [
    { id: "A",   x: 100, y: 300, r: 42, d: 14, tipo: "motor" },
    { id: "B",   x: 190, y: 300, r: 32, d: 10, tipo: "normal" },
    { id: "C",   x: 275, y: 300, r: 26, d: 7,  tipo: "trava" },
    { id: "D",   x: 350, y: 300, r: 22, d: 6,  tipo: "normal" },
    { id: "E",   x: 435, y: 300, r: 30, d: 9,  tipo: "normal" },
    { id: "F",   x: 520, y: 300, r: 22, d: 6,  tipo: "trava" },
    { id: "G",   x: 605, y: 300, r: 28, d: 8,  tipo: "normal" },
    { id: "H",   x: 275, y: 160, r: 20, d: 5,  tipo: "aux" },
    { id: "I",   x: 520, y: 160, r: 20, d: 5,  tipo: "aux" },
    { id: "OUT", x: 710, y: 430, r: 38, d: 10, tipo: "saida" }
];

// ==========================================
// SISTEMA II: PAINEL ELÉTRICO
// ==========================================
tensao_out = 0;
fusivel_queimado = false;
curto_circuito = false;
ele_resolvido = false;
conexoes_ele = [];

// Esquemático de Componentes Elétricos
nos_ele = [
    { id: "BAT-A", x: 80,  y: 150, tipo: "bat", v: 6 },
    { id: "BAT-B", x: 80,  y: 230, tipo: "bat", v: 4 },
    { id: "BAT-C", x: 80,  y: 310, tipo: "bat", v: 3 },
    { id: "BAT-D", x: 80,  y: 390, tipo: "bat", v: 2 },
    { id: "D1",    x: 220, y: 150, tipo: "diodo" },
    { id: "R1",    x: 220, y: 230, tipo: "res" },
    { id: "C1",    x: 220, y: 310, tipo: "cap" },
    { id: "R2",    x: 220, y: 390, tipo: "res" },
    { id: "J1",    x: 370, y: 190, tipo: "no" },
    { id: "J2",    x: 370, y: 350, tipo: "no" },
    { id: "Q1",    x: 490, y: 190, tipo: "trans" },
    { id: "Q2",    x: 490, y: 350, tipo: "trans" },
    { id: "J3",    x: 600, y: 270, tipo: "no" },
    { id: "F1",    x: 680, y: 220, tipo: "fusivel" },
    { id: "K1",    x: 680, y: 320, tipo: "rele" },
    { id: "OUT",   x: 755, y: 270, tipo: "saida" },
    { id: "GND-1", x: 370, y: 470, tipo: "gnd" },
    { id: "GND-2", x: 680, y: 430, tipo: "gnd" }
];

function get_eng_idx(_id) {
    for(var i=0; i<array_length(engrenagens); i++) { if(engrenagens[i].id == _id) return i; }
    return -1;
}
function get_ele_idx(_id) {
    for(var i=0; i<array_length(nos_ele); i++) { if(nos_ele[i].id == _id) return i; }
    return -1;
}