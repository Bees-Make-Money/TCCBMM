y_atual -= velocidade_rolagem;
if (y_atual < -altura_total_creditos) {
    // Depois de um final, o jogo recomeça do zero; pelo botão do menu, só volta para a interface
    if (global.ending_id != 0) game_restart();
}