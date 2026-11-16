// depois de salvar, espera um instante e fecha o jogo
if (exit_t > 0) {
    exit_t--;
    if (exit_t == 0) game_end();
    exit;
}

// ESC (ou P) abre e fecha
if (keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"))) {
    if (!open) {
        if (can_pause()) open_menu();
    }
    else {
        if (mode == "main") close_menu();
        else if (mode == "confirm_reset") mode = "main";
    }
}

if (!open) {
    hover = -1;
    exit;
}

if (msg_t > 0) msg_t--;

// botão sob o mouse
var _n = 0;
if (mode == "main") _n = 3;
else if (mode == "confirm_reset") _n = 2;

hover = -1;
for (var i = 0; i < _n; i++) {
    var _r = btn_rect(i);
    if (point_in_rectangle(mouse_x, mouse_y, _r[0], _r[1], _r[2], _r[3])) hover = i;
}

// clique
if (mouse_check_button_pressed(mb_left) && hover != -1) {

    if (mode == "main") {
        switch (hover) {
            case 0:   // continuar
                close_menu();
            break;

            case 1:   // salvar e sair
                if (!can_save_here()) {
                    msg = "Não é possível salvar durante este momento.";
                    msg_t = 200;
                }
                else if (scr_save_game()) {
                    mode = "saving";
                    exit_t = 90;
                }
                else {
                    msg = "Não foi possível salvar.";
                    msg_t = 200;
                }
            break;

            case 2:   // resetar (pede confirmação)
                mode = "confirm_reset";
            break;
        }
    }
    else if (mode == "confirm_reset") {
        if (hover == 0) scr_reset_progress(reset_deletes_save);   // sim
        else mode = "main";                                       // não
    }
}
