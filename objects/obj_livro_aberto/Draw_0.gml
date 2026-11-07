draw_set_alpha(0.8);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

var _sw = sprite_get_width(sprite_index) * book_scale;
var _sh = sprite_get_height(sprite_index) * book_scale;
var _left = room_width / 2 - _sw / 2;      
var _top = room_height / 2 - _sh / 2;      
draw_sprite_ext(sprite_index, 0, _left + sprite_get_xoffset(sprite_index) * book_scale, _top + sprite_get_yoffset(sprite_index) * book_scale, book_scale, book_scale, 0, c_white, 1);

var _tx = _left + page_left * book_scale;
var _ty = _top + page_top * book_scale;
var _tw = (page_right - page_left) * book_scale;

draw_set_font(fnt_testes);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(text_color);
draw_text_ext(_tx, _ty, book_text, -1, _tw);


draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(room_width / 2, room_height - 40, "Esc: fechar");

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);