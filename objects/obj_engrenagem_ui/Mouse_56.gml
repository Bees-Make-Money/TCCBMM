var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

if (!arrastando) exit;

// ── Soltar em engrenagem ──
if (aba == 0) {
    for (var i = 0; i < array_length(eng); i++) {
        if (i == arr_origem) continue;
        var e = eng[i];
        if (point_in_circle(mx, my, e.ex, e.ey, e.r + 6)) {
            for (var f = 0; f < array_length(conexoes_eng); f++) {
                var c = conexoes_eng[f];
                if (!c.ok) {
                    if ((c.de == arr_origem && c.para == i) ||
                        (c.de == i && c.para == arr_origem)) {
                        conexoes_eng[f].ok      = true;
                        eng[c.de].conectada     = true;
                        eng[c.para].conectada   = true;
                        eng_ok++;
                        if (eng_ok == 1) instrucao = "Prossiga com o Manual.";
                        if (eng_ok == 2) instrucao = "Continue o concerto";
                    }
                }
            }
            break;
        }
    }
}

// ── Soltar em nó de fiação ──
if (aba == 1) {
    for (var i = 0; i < array_length(nos); i++) {
        if (i == arr_origem) continue;
        var n = nos[i];
        if (point_in_circle(mx, my, n.nx, n.ny, raio_no)) {
            for (var f = 0; f < array_length(conexoes_fio); f++) {
                var c = conexoes_fio[f];
                if (!c.ok) {
                    if ((c.de == arr_origem && c.para == i) ||
                        (c.de == i && c.para == arr_origem)) {
                        conexoes_fio[f].ok  = true;
                        nos[c.de].ligado    = true;
                        nos[c.para].ligado  = true;
                        fio_ok++;
                        if (fio_ok < 3) instrucao = "Conclua o processo seguindo o manual";
                    }
                }
            }
            break;
        }
    }
}

arrastando = false;
arr_origem = -1;