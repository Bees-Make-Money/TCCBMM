if (pre_wait > 0) {
    pre_wait--;
    exit;
}

timer++;

switch (phase) {
    case 0:                          // escurecendo devagar
        alpha = min(1, timer / dark_steps);
        if (timer >= dark_steps) { phase = 1; timer = 0; }
    break;

    case 1:                          // tela toda escura
        alpha = 1;
        if (timer >= hold_steps) { phase = 2; timer = 0; }
    break;

    case 2:                          // jumpscare
        if (timer >= scare_steps) { phase = 3; timer = 0; }
    break;

    case 3:                          // imagem fantasma
        if (timer >= ghost_steps) { phase = 4; timer = 0; }
    break;

    case 4:                          // texto
        text_alpha = min(1, timer / (0.8 * fps_game));
        if (timer >= text_steps) { phase = 5; timer = 0; }
    break;

    case 5:                          // créditos
        global.ending_id = ending_id;
        phase = 6;
        room_goto(rm_creditos);
    break;
}