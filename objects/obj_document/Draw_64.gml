draw_set_font(fnt_testes);

draw_set_alpha(0.8);
draw_set_color(c_fundo);
draw_rectangle(0, 0, w, h, false);
draw_set_alpha(1);

draw_set_color(c_papel);
draw_rectangle(bx1, by1, bx2, by2, false);
draw_set_color(c_tinta);
draw_rectangle(bx1, by1, bx2, by2, true);

// Botão Fechar
draw_text(bx2 - 25, by1 + 15, "X");
draw_rectangle(bx2 - 35, by1 + 10, bx2 - 15, by1 + 30, true);

// Mecânica de Revelação
var revelado = mouse_check_button(mb_right);

draw_set_halign(fa_left);

var max_largura = (bx2 - bx1) - 80; // Largura máxima antes de quebrar a linha
var sep = 25; // Espaçamento entre as linhas

draw_set_halign(fa_left);

switch (pag_atual) {
    case 0:
        draw_set_color(c_tinta);
        draw_text_ext(bx1 + 40, by1 + 60, "Minha doce estrela,\n\nA cada dia que passo longe de voce, sinto como se as engrenagens da minha vida estivessem travadas. Lembro-me daquela noite no jardim, sob a luz do luar.", sep, max_largura);
        
        if (revelado) {
            draw_set_color(c_oculto);
            draw_text_ext(bx1 + 40, by1 + 250, "[OCULTO] A sequencia de ignicao comeca com o numero 7.", sep, max_largura);
        }
        break;

    case 1:
        draw_set_color(c_tinta);
        draw_text_ext(bx1 + 40, by1 + 60, "Escrevo estas palavras torcendo para que a brisa as leve ate a sua janela.\n\nNosso tempo juntos foi a forca motriz que me deu energia para construir tudo o que temos hoje.", sep, max_largura);
        
        if (revelado) {
            draw_set_color(c_oculto);
            draw_text_ext(bx1 + 40, by1 + 220, "[OCULTO] O pino de trava principal e a Engrenagem D.\n[OCULTO] Avance a rotacao em 4 graus para alinhar.", sep, max_largura);
        }
        break;

    case 2:
        draw_set_color(c_tinta);
        draw_text_ext(bx1 + 40, by1 + 60, "Guarde esta carta perto do calor do seu coracao. Ha verdades que so se revelam para quem olha com atencao.\n\nPara sempre seu,\n\n- A.", sep, max_largura);
        
        if (revelado) {
            draw_set_color(c_oculto);
            draw_text_ext(bx1 + 40, by1 + 220, "[OCULTO] CODIGO FINAL: 7-D-4", sep, max_largura);
        }
        break;
}

// Dica de Interface
draw_set_halign(fa_center);
draw_set_color(c_tinta);
if (!revelado) {
    draw_text(w/2, by2 + 20, "(Segure o Botao Direito do Mouse para revelar segredos)");
}

// Botões
if (pag_atual > 0) {
    draw_rectangle(bx1 + 20, by2 - 50, bx1 + 140, by2 - 10, true);
    draw_text(bx1 + 80, by2 - 40, "<- VOLTAR");
}
if (pag_atual < pag_max) {
    draw_rectangle(bx2 - 140, by2 - 50, bx2 - 20, by2 - 10, true);
    draw_text(bx2 - 80, by2 - 40, "AVANCAR ->");
}
draw_set_halign(fa_left);