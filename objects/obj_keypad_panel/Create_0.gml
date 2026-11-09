depth = -500;
scr_lock();

can_click = false;      // ignora o clique que abriu o painel
typed = "";
max_len = 6;
bad_timer = 0;

// ---- Sprite do painel ----
sprite_index = spr_keypad_panel;
image_speed = 0;
image_index = 0;
x = room_width / 2;                 // centro do painel na sala
y = room_height / 2;
image_xscale = 1;
image_yscale = 1;

// Canto superior esquerdo do sprite na sala (funciona com qualquer origem)
panel_x = x - sprite_get_xoffset(sprite_index) * image_xscale;
panel_y = y - sprite_get_yoffset(sprite_index) * image_yscale;

// ---- Medidas dentro do sprite (pixels do sprite, a partir do canto superior esquerdo) ----
visor_rx = 43;   visor_ry = 37;   visor_rw = 540;  visor_rh = 81;    // área laranja do visor
grid_rx  = 40;   grid_ry  = 143;                                      // canto do botão "A"
btn_w = 65;      btn_h = 65;                                          // tamanho de cada botão
gap_x = 15;      gap_y = 15;                                          // espaço entre botões
cols = 7;                                                             // 7 / 7 / 7 / 5 (última linha começa na 2ª coluna)

// Visor na sala
visor_x = panel_x + visor_rx * image_xscale;
visor_y = panel_y + visor_ry * image_yscale;
visor_w = visor_rw * image_xscale;
visor_h = visor_rh * image_yscale;

// Retângulo [x1, y1, x2, y2] do botão da letra i (0 = A ... 25 = Z), em pixels da sala
button_rect = function(_i) {
    var _col = _i mod cols;
    var _row = _i div cols;
    if (_row == 3) _col += 1;       // V W X Y Z ficam deslocados uma coluna
    var _x1 = panel_x + (grid_rx + _col * (btn_w + gap_x)) * image_xscale;
    var _y1 = panel_y + (grid_ry + _row * (btn_h + gap_y)) * image_yscale;
    return [_x1, _y1, _x1 + btn_w * image_xscale, _y1 + btn_h * image_yscale];
};

// Enter: confere a senha
submit = function() {
    if (typed == "FUJA" && scr_flag("final_books_done") && !scr_flag("hotel_burned")) {
        scr_final_fuja_accepted();
        instance_destroy();
		instance_destroy(obj_livro_02)
		instance_destroy(obj_livro_07)
		instance_destroy(obj_livro_11)
		instance_destroy(obj_livro_18)
		instance_destroy(obj_livro_25)
        return;
    }
    // (a senha SLEEP entra na Fase 8)
    bad_timer = 30;
    typed = "";
};