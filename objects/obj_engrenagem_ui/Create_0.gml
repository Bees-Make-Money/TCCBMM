px = display_get_gui_width()  / 2 - 270;
py = display_get_gui_height() / 2 - 210;
pw = 540;
ph = 420;

cor_ouro   = make_color_rgb(200, 150, 30);
cor_borda  = make_color_rgb(122, 92, 32);
cor_painel = make_color_rgb(26, 18, 8);
cor_verde  = make_color_rgb(64, 168, 64);
cor_verm   = make_color_rgb(200, 64, 32);

// Aba ativa: 0 = engrenagens, 1 = fiacao
aba = 0;
aba_eng_ok  = false;
aba_fio_ok  = false;

// Porta visual
porta_x = px + pw - 120;
porta_y = py + 80;
porta_w = 80;
porta_h = 140;

// ── ENGRENAGENS ──
eng = [
    { ex: px+90,  ey: py+190, r: 38, dentes: 12, label: "A", conectada: false },
    { ex: px+220, ey: py+140, r: 28, dentes: 8,  label: "B", conectada: false },
    { ex: px+330, ey: py+190, r: 22, dentes: 6,  label: "C", conectada: false },
    { ex: px+220, ey: py+250, r: 22, dentes: 6,  label: "D", conectada: false }
];

conexoes_eng = [
    { de: 0, para: 1, ok: false },
    { de: 1, para: 2, ok: false },
    { de: 1, para: 3, ok: false }
];
eng_ok = 0;

// ── FIAÇÃO ──
// Pinos superiores (fonte) e terminais inferiores (destino)
nos = [
    { nx: px+70,  ny: py+110, label: "P1", ligado: false },
    { nx: px+190, ny: py+110, label: "P2", ligado: false },
    { nx: px+310, ny: py+110, label: "P3", ligado: false },
    { nx: px+70,  ny: py+230, label: "T1", ligado: false },
    { nx: px+190, ny: py+230, label: "T2", ligado: false },
    { nx: px+310, ny: py+230, label: "T3", ligado: false }
];

conexoes_fio = [
    { de: 0, para: 3, ok: false },
    { de: 1, para: 4, ok: false },
    { de: 2, para: 5, ok: false }
];
fio_ok = 0;

// Arrasto
arrastando = false;
arr_origem = -1;
arr_x = 0;
arr_y = 0;
raio_no = 16;

// Animação das engrenagens
angulo = 0;

// Instruções
instrucao = "Leia o Manual";

// Botão voltar
btn_voltar_x = px + pw/2 - 80;
btn_voltar_y = py + ph - 38;
btn_voltar_w = 160;
btn_voltar_h = 30;

// Abas
aba_eng_x = px;
aba_fio_x = px + pw/2;
aba_y     = py - 32;
aba_w     = pw/2;
aba_h     = 32;