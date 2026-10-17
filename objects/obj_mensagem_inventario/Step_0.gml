if (msg_ativada) {
    if (msg_timer > 0) {
        msg_alpha = min(msg_alpha + msg_fade_speed, 1);
        msg_timer--;
    } 
    else {
        msg_alpha = max(msg_alpha - msg_fade_speed, 0);
        if (msg_alpha == 0) {
            msg_ativada = false;
        }
    }
}
