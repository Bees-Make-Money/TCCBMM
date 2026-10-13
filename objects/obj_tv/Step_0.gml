var _act = tv_is_active();

// aviso quando a TV aparece (só se aparecer enquanto o jogador está na sala)
if (_act && !tv_was_active) announce_timer = 20;
tv_was_active = _act;

if (announce_timer > 0 && !global.interaction_locked) {
    announce_timer--;
    if (announce_timer == 0) {
        scr_show_dialog(["Uma televisão de luxo surgiu na sala. Talvez as peças que encontrei façam sentido com ela."], "Detetive", c_white);
    }
}

if (!_act) {
    hover_card = -1;
    exit;
}

// fase atual (calculada a partir das flags)
if (!scr_flag("tv_on"))                       tv_phase = "off";
else if (!scr_flag("console_connected"))      tv_phase = "bars";
else if (!scr_flag("controller_connected"))   tv_phase = "console";
else if (!menu_ready)                         tv_phase = "message";
else                                          tv_phase = "menu";

// mensagem sendo digitada na tela
if (tv_phase == "message") {
    if (msg_index < string_length(tv_message)) {
        msg_index += 0.2;
    }
    else {
        msg_hold++;
        if (msg_hold >= 90) menu_ready = true;
    }
}

// cartão sob o mouse
hover_card = -1;
if (tv_phase == "menu" && !global.interaction_locked) {
    for (var i = 0; i < 3; i++) {
        var _r = card_rect(i);
        if (point_in_rectangle(mouse_x, mouse_y, _r[0], _r[1], _r[2], _r[3])) hover_card = i;
    }
}
if (hover_card != prev_hover) {
    window_set_cursor((hover_card != -1) ? cr_handpoint : cr_default);
    prev_hover = hover_card;
}

was_locked = global.interaction_locked;
