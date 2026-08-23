draw_set_font(fnt_testes); 
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);
var _x_centro = room_width / 2;
for (var i = 0; i < array_length(texto_creditos); i++) {
    var _y_linha = y_atual + (i * espacamento_linha);
    if (_y_linha > -espacamento_linha && _y_linha < room_height + espacamento_linha) {
        draw_text(_x_centro, _y_linha, texto_creditos[i]);
    }}
draw_set_halign(fa_left);
draw_set_valign(fa_top);