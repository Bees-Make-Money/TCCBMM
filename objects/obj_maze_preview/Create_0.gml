depth = -1000;
if(room = rm_labirinto_1) {hold_steps = 1.2 * game_get_speed(gamespeed_fps);}
if(room = rm_labirinto_2) {hold_steps = 1.5 * game_get_speed(gamespeed_fps);} // 4 s com o labirinto totalmente visível
fade_steps = 1 * game_get_speed(gamespeed_fps);   // 1 s para a escuridão voltar
allow_skip = true;                                // Espaço pula a visualização
timer = 0;
darkness = 0;                                     // 0 = sem escuridão; 1 = escuridão normal
scr_lock();                                       // jogador, contador e projéteis ficam parados