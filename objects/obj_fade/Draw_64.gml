var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

draw_set_alpha(alpha);        
draw_set_color(c_black);        
// Estende para além da área da GUI, cobrindo as faixas pretas laterais (pegar a caixa de objetivos)
draw_rectangle(-_gw, -_gh, _gw * 2, _gh * 2, false);
draw_set_alpha(1);
draw_set_color(c_white);