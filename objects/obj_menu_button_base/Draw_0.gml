var _sobre = point_in_rectangle(mouse_x, mouse_y, x, y, x + largura, y + altura);
var _press = _sobre && mouse_check_button(mb_left);
hover = lerp(hover, _sobre ? 1 : 0, 0.2);

if (_sobre != sobre_anterior) {
    window_set_cursor(_sobre ? cr_handpoint : cr_default);
    sobre_anterior = _sobre;
}

// Paleta tirada dos cenários
var _madeira_escura = make_color_rgb(32, 18, 14);
var _madeira        = make_color_rgb(62, 36, 26);
var _vermelho       = make_color_rgb(140, 24, 40);
var _dourado        = make_color_rgb(214, 168, 72);
var _dourado_claro  = make_color_rgb(255, 226, 150);
var _creme          = make_color_rgb(240, 228, 200);

var _x1 = x + hover * 10;
var _y1 = y + (_press ? 2 : 0);
var _x2 = _x1 + largura;
var _y2 = _y1 + altura;
var _cx = (_x1 + _x2) / 2;
var _cy = (_y1 + _y2) / 2;



// Brilho externo no hover
draw_set_color(_dourado_claro);
for (var i = 1; i <= 4; i++) {
    draw_set_alpha(hover * 0.18 / i);
    draw_rectangle(_x1 - i, _y1 - i, _x2 + i, _y2 + i, true);
}

// Fundo transparente: só um tom avermelhado leve quando o mouse passa
var _fundo_alpha = 0;   // 0 = totalmente transparente (ex.: 0.2 escurece um pouco)
draw_set_color(c_black);
draw_set_alpha(_fundo_alpha);
draw_rectangle(_x1, _y1, _x2, _y2, false);

draw_set_color(_vermelho);
draw_set_alpha(hover * 0.35);
draw_rectangle(_x1, _y1, _x2, _y2, false);

// Borda dupla dourada
var _cor_borda = merge_color(_dourado, _dourado_claro, hover);
draw_set_color(_cor_borda);
draw_set_alpha(1);
draw_rectangle(_x1, _y1, _x2, _y2, true);
draw_rectangle(_x1 + 1, _y1 + 1, _x2 - 1, _y2 - 1, true);
draw_set_alpha(0.55);
draw_rectangle(_x1 + 5, _y1 + 5, _x2 - 5, _y2 - 5, true);

// Losangos laterais
draw_set_alpha(0.6 + hover * 0.4);
draw_triangle(_x1 + 18, _cy, _x1 + 26, _cy - 8, _x1 + 34, _cy, false);
draw_triangle(_x1 + 18, _cy, _x1 + 26, _cy + 8, _x1 + 34, _cy, false);
draw_triangle(_x2 - 34, _cy, _x2 - 26, _cy - 8, _x2 - 18, _cy, false);
draw_triangle(_x2 - 34, _cy, _x2 - 26, _cy + 8, _x2 - 18, _cy, false);

// Texto
draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_alpha(1);
draw_set_color(c_black);
draw_text(_cx + 2, _cy + 2, texto_botao);
draw_set_color(merge_color(_creme, _dourado_claro, hover));
draw_text(_cx, _cy, texto_botao);

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_set_alpha(1);