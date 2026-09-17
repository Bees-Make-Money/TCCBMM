// Calcula o centro dinâmico baseado na escala
var cx = x + (largura / 2) + 100;
var cy = y + (altura / 2);
var l = (largura / 2) * escala;
var a = (altura / 2) * escala;

// Desenha a sombra
draw_set_color(c_borda);
draw_rectangle(cx - l + 4, cy - a + 4, cx + l + 4, cy + a + 4, false);

// Desenha o fundo do papel
draw_set_color(c_papel);
draw_rectangle(cx - l, cy - a, cx + l, cy + a, false);

// Desenha o contorno
draw_set_color(c_tinta);
draw_rectangle(cx - l, cy - a, cx + l, cy + a, true);

// Desenha os detalhes (Título e linhas de texto simuladas)
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed(cx, cy - 20, "MANUAL", escala * 0.7, escala * 0.7, 0);

// Linhas decorativas imitando parágrafos
draw_line_width(cx - 25 * escala, cy + 10 * escala, cx + 25 * escala, cy + 10 * escala, 2 * escala);
draw_line_width(cx - 25 * escala, cy + 25 * escala, cx + 10 * escala, cy + 25 * escala, 2 * escala);

// Reseta os alinhamentos para não quebrar outros desenhos do jogo
draw_set_halign(fa_left);
draw_set_valign(fa_top);