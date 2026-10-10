draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Garante que o título ampliado não seja cortado na borda esquerda da tela
var _meia_largura = (string_width(texto_titulo) * titulo_escala) / 2;
var _x = max(titulo_x, _meia_largura + 20);

// Sombra (o deslocamento também cresce com a escala, para manter a proporção)
draw_set_color(c_black);
draw_text_transformed(_x + 2 * titulo_escala, titulo_y + 2 * titulo_escala, texto_titulo, titulo_escala, titulo_escala, 0);

// Texto
draw_set_color(c_white);
draw_text_transformed(_x, titulo_y, texto_titulo, titulo_escala, titulo_escala, 0);

draw_set_halign(fa_left);
draw_set_valign(fa_top);