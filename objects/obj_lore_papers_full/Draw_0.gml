draw_set_alpha(0.8)
draw_set_colour(c_black)
draw_rectangle(0, 0, room_width, room_height, false)

draw_self()

draw_set_font(fnt_testes)
draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_colour(c_black)

var text_x = x - (text_area_width/2)
var text_y = y - (text_area_height/2)

draw_text_ext(text_x, text_y, lore_part, -1, text_area_width)

draw_set_halign(fa_left)
draw_set_valign(fa_top)
draw_set_color(c_white)