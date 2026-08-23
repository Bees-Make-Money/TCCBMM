y_atual -= velocidade_rolagem;
if (y_atual < -altura_total_creditos) {
    y_atual = room_height;
}