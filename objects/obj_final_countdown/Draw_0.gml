var _secs = ceil(max(global.final_timer, 0) / fps_game);
var _txt = string(_secs div 60) + ":" + ((_secs mod 60) < 10 ? "0" : "") + string(_secs mod 60);

// Nos últimos 10 segundos o número "pulsa"
var _scale = 2 + ((_secs <= 10) ? 0.4 * abs(sin(current_time * 0.01)) : 0);

draw_set_font(fnt_testes);
draw_set_halign(fa_right);
draw_set_valign(fa_top);

draw_set_color(c_black);                                              // sombra
draw_text_transformed(room_width - 22, 22, _txt, _scale, _scale, 0);
draw_set_color(c_red);                                                // texto
draw_text_transformed(room_width - 24, 20, _txt, _scale, _scale, 0);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);