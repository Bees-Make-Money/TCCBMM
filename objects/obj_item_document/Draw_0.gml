var bx = x - btn_w/2;
var by = y - btn_h/2;

hover = point_in_rectangle(mouse_x, mouse_y, bx, by, bx+btn_w, by+btn_h);

draw_set_color(hover ? make_color_rgb(38, 26, 10) : cor_painel);
draw_rectangle(bx, by, bx+btn_w, by+btn_h, false);

draw_set_color(hover ? cor_ouro_cl : cor_borda);
draw_rectangle(bx, by, bx+btn_w, by+btn_h, true);

// Cantos decorativos
draw_set_color(cor_ouro);
draw_set_alpha(0.7);
draw_line(bx+4,       by+4,       bx+12,        by+4);
draw_line(bx+4,       by+4,       bx+4,         by+12);
draw_line(bx+btn_w-4, by+4,       bx+btn_w-12,  by+4);
draw_line(bx+btn_w-4, by+4,       bx+btn_w-4,   by+12);
draw_line(bx+4,       by+btn_h-4, bx+12,        by+btn_h-4);
draw_line(bx+4,       by+btn_h-4, bx+4,         by+btn_h-12);
draw_line(bx+btn_w-4, by+btn_h-4, bx+btn_w-12,  by+btn_h-4);
draw_line(bx+btn_w-4, by+btn_h-4, bx+btn_w-4,   by+btn_h-12);
draw_set_alpha(1);

draw_set_color(make_color_rgb(58, 42, 8));
draw_line(bx+18, by+8, bx+btn_w-18, by+8);

draw_set_color(hover ? cor_ouro_cl : cor_ouro);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_testes);
draw_text(x, y, "LER ARQUIVO");
draw_set_valign(fa_top);