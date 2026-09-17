// Detecta a posição do mouse em relação ao desenho do botão
hover = point_in_rectangle(mouse_x, mouse_y, x, y, x + largura, y + altura);

if (hover) {
    escala = lerp(escala, 1.1, 0.15); // Expande suavemente
    window_set_cursor(cr_handpoint);  // Muda o cursor para a mãozinha
    
    // Cria o manual ao clicar
    if (mouse_check_button_pressed(mb_left)) {
        if (!instance_exists(obj_instruction1)) {
            instance_create_depth(0, 0, -100, obj_instruction1);
            window_set_cursor(cr_default); // Reseta o cursor ao abrir
        }
    }
} else {
    escala = lerp(escala, 1.0, 0.15); // Retorna ao tamanho original
    
    // Garante que o cursor volte ao normal apenas se estiver em cima deste objeto
    if (escala > 1.05) window_set_cursor(cr_default); 
}