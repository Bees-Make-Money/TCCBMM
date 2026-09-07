var cx = display_get_gui_width()  / 2;
var cy = display_get_gui_height() / 2;

// Fundo do manual (papel amarelado)
draw_set_color(make_color_rgb(232, 223, 200));
draw_set_alpha(0.97);
draw_rectangle(cx-170, cy-160, cx+200, cy+180, false);
draw_set_alpha(1);

// Linha vermelha de margem (estética de caderno)
draw_set_color(make_color_rgb(180, 60, 60));
draw_set_alpha(0.4);
draw_line(cx-120, cy-160, cx-120, cy+160);
draw_set_alpha(1);

// Conteúdo da página atual
draw_set_color(make_color_rgb(42, 31, 14));
draw_set_halign(fa_left);
draw_set_font(fnt_testes);
draw_text_ext(cx-110, cy-130, paginas[pagina_atual], 22, 280);

// Rodapé de navegação
draw_set_halign(fa_center);
draw_set_color(make_color_rgb(120, 90, 50));
draw_text(cx, cy+135, "◄ A  |  " + string(pagina_atual+1) + "/" + string(array_length(paginas)) + "  |  D ►");

// Fechar
draw_set_color(make_color_rgb(100, 60, 30));
draw_text(cx+165, cy-150, "[ESC]");