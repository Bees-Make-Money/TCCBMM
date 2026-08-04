largura = 200;
altura = 60;  
draw_self();
var _cor_fundo = make_color_rgb(45, 52, 54);  
var _cor_borda = make_color_rgb(116, 185, 255);
var _cor_texto = c_white;
if (position_meeting(mouse_x, mouse_y, id)) {
    _cor_fundo = make_color_rgb(9, 132, 227); 
    if (mouse_check_button(mb_left)) {
        _cor_fundo = make_color_rgb(11, 79, 134); 
    }
}
draw_set_color(_cor_fundo);
draw_roundrect_ext(x, y, x + largura, y + altura, 20, 20, false);
draw_set_color(_cor_borda);
draw_roundrect_ext(x, y, x + largura, y + altura, 20, 20, true);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(_cor_texto);



draw_text(x + (largura / 2), y + (altura / 2), texto);