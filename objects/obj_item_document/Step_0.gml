
hover = point_in_rectangle(mouse_x, mouse_y, x, y, x + largura, y + altura);

if (hover) {
    escala = lerp(escala, 1.1, 0.15);
    window_set_cursor(cr_handpoint);
    
    if (mouse_check_button_pressed(mb_left)) {
        if (!instance_exists(obj_document)) {
            instance_create_depth(0, 0, -100, obj_document);
            window_set_cursor(cr_default);
        }
    }
} else {
    escala = lerp(escala, 1.0, 0.15);
    if (escala > 1.05) window_set_cursor(cr_default);
}