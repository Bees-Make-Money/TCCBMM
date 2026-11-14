depth = -1500;        // acima dos quadros e das garras; abaixo da tela de morte (-9999)
duration = 60;        // steps (60 = 1 segundo)
timer = 0;
peak_done = false;
on_peak = -1;         // função chamada no pico do efeito (a troca acontece escondida pelo flash)
on_done = -1;         // função chamada quando o efeito termina
scr_lock();           // o jogador não pode clicar durante o efeito         