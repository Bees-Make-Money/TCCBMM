// Intensidade: sobe até 1 no meio e desce até 0 no fim
var _t = timer / duration;
var _k = 1 - abs(_t * 2 - 1);

// 1) Flash de tela inteira, piscando (branco, preto ou vermelho)
if (irandom(2) > 0) {
    draw_set_color(choose(c_white, c_black, c_red));
    draw_set_alpha(_k * random_range(0.3, 0.8));
    draw_rectangle(0, 0, room_width, room_height, false);
}

// 2) Barras horizontais de "interferência", em posições aleatórias
repeat (floor(_k * 14)) {
    var _y = irandom(room_height);
    var _h = irandom_range(3, 36);
    draw_set_color(choose(c_white, c_black, c_aqua, c_red));
    draw_set_alpha(_k * random_range(0.4, 1));
    draw_rectangle(0, _y, room_width, _y + _h, false);
}

// 3) No pico, a tela fica totalmente coberta por 5 steps: é aqui que a troca acontece
if (abs(timer - duration / 2) <= 2) {
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_rectangle(0, 0, room_width, room_height, false);
}

// Restaura o estado de desenho
draw_set_alpha(1);
draw_set_color(c_white);