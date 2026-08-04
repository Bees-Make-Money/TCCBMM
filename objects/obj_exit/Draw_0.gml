draw_self(); 
var _cor_fundo = make_color_rgb(45, 52, 54); 
if (position_meeting(mouse_x, mouse_y, id)) {
    _cor_fundo = make_color_rgb(214, 48, 49);
}
draw_set_color(_cor_fundo);
draw_roundrect_ext(x, y, x + 200, y + 60, 20, 20, false);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(x + 100, y + 30, "SAIR");