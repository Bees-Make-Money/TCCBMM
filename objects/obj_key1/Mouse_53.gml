var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Verifica clique nos dígitos 1–9
for (var d = 1; d <= 9; d++) {
    var col = (d-1) mod 3;
    var row = (d-1) div 3;
    var bx  = gx + col * (btn_w + btn_gap);
    var by  = gy + row * (btn_h + btn_gap);

    if (point_in_rectangle(mx, my, bx, by, bx+btn_w, by+btn_h)) {
        if (string_length(entrada) < max_digitos)
            entrada += string(d);
    }
}
 // Verifica clique no dígito 0
var zero_y = gy + 3*(btn_h + btn_gap);
var zero_w = btn_w*3 + btn_gap*2;
if (point_in_rectangle(mx, my, gx, zero_y, gx+zero_w, zero_y+btn_h)) {
    if (string_length(entrada) < max_digitos)
        entrada += "0";
}

// Botão apagar (← no display)
var del_x = px + pw - 50;
var del_y = py + 100;
if (point_in_rectangle(mx, my, del_x, del_y, del_x+30, del_y+28)) {
    if (string_length(entrada) > 0)
        entrada = string_copy(entrada, 1, string_length(entrada)-1);
    dica = "";
}

// Botão confirmar
if (string_length(entrada) == max_digitos) {
    if (point_in_rectangle(mx, my, confirm_x, confirm_y, confirm_x+confirm_w, confirm_y+confirm_h))
        verificar_senha();
}