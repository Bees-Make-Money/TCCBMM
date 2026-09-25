if (alpha_fundo < 1) {
    alpha_fundo += 0.01;
} 
else {
    if (char_index < string_length(texto)) {
        char_index += vel_texto;
        texto_exibido = string_copy(texto, 1, floor(char_index));
    } 
    else {
        mostrar_botao = true;
    }
}