// ═══════════════════════════════════════════════════════════════
// GLOBAL LEFT PRESSED - Seleção por Clique de Mouse
// ═══════════════════════════════════════════════════════════════
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Alternância de Abas
if (my >= 16 && my <= 52) {
    if (mx >= 180 && mx <= 390) { aba = 0; return; }
    if (mx >= 410 && mx <= 620) { aba = 1; return; }
}

arrastando = false;
arr_from = "";

if (aba == 0) {
    for(var i=0; i<array_length(engrenagens); i++) {
        var e = engrenagens[i];
        if (point_distance(mx, my, e.x, e.y) <= e.r) {
            arrastando = true;
            arr_from = e.id;
            break;
        }
    }
} else {
    for(var i=0; i<array_length(nos_ele); i++) {
        var n = nos_ele[i];
        if (point_distance(mx, my, n.x, n.y) <= 22) {
            arrastando = true;
            arr_from = n.id;
            break;
        }
    }
}