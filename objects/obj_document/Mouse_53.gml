var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Botão X
if (mx >= bx2 - 40 && mx <= bx2 - 10 && my >= by1 + 10 && my <= by1 + 40) {
    instance_destroy();
    return;
}

// Anterior
if (pag_atual > 0 && mx >= bx1 + 20 && mx <= bx1 + 140 && my >= by2 - 50 && my <= by2 - 10) {
    pag_atual--;
    return;
}

// Próxima
if (pag_atual < pag_max && mx >= bx2 - 140 && mx <= bx2 - 20 && my >= by2 - 50 && my <= by2 - 10) {
    pag_atual++;
    return;
}