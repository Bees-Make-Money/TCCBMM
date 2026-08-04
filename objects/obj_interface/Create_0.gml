
largura_tela = 816;
altura_tela = 624;


altura_botao = 60;
espacamento = 20;
num_botoes =4;


altura_total_botoes = (num_botoes * altura_botao) + ((num_botoes - 1) * espacamento);
y_inicial = (altura_tela - altura_total_botoes) / 2;


x_centro = largura_tela / 2;

botoes = [
    inst_obj_creditos,
    inst_obj_exit,
    inst_obj_play_button,
    inst_obj_sound
];


for (var i = 0; i < array_length(botoes); i++) {
    botoes[i].x = x_centro;
    botoes[i].y = y_inicial + (i * (altura_botao + espacamento));}