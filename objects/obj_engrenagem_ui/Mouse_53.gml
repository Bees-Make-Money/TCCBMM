var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// ── Clique nas abas ──
if (point_in_rectangle(mx, my, aba_eng_x, aba_y, aba_eng_x+aba_w, aba_y+aba_h)) {
    aba = 0;
    exit;
}
if (point_in_rectangle(mx, my, aba_fio_x, aba_y, aba_fio_x+aba_w, aba_y+aba_h)) {
    aba = 1;
    exit;
}

// ── Botão voltar ──
if (point_in_rectangle(mx, my, btn_voltar_x, btn_voltar_y,
    btn_voltar_x+btn_voltar_w, btn_voltar_y+btn_voltar_h)) {
    instance_destroy();
    exit;
}

// ── Aba engrenagens ──
if (aba == 0) {
    for (var i = 0; i < array_length(eng); i++) {
        var e = eng[i];
        if (point_in_circle(mx, my, e.ex, e.ey, e.r + 6)) {
            arrastando = true;
            arr_origem = i;
            arr_x = mx;
            arr_y = my;
            break;
        }
    }
}

// ── Aba fiação ──
if (aba == 1) {
    for (var i = 0; i < array_length(nos); i++) {
        var n = nos[i];
        if (point_in_circle(mx, my, n.nx, n.ny, raio_no)) {
            arrastando = true;
            arr_origem = i;
            arr_x = mx;
            arr_y = my;
            break;
        }
    }
}