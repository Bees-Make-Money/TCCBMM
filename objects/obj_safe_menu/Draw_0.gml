draw_set_alpha(0.8)
draw_set_colour(c_black)
draw_rectangle(0, 0, room_width, room_height, false)

draw_self();

draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);

for (var i = 0; i < 4; i++) {
    var pos_x = start_x + i * (square_width + spacing);
    var pos_y = start_y;
	
    draw_set_color(c_dkgray);
    draw_rectangle(pos_x - square_width/2, pos_y - square_height/2, pos_x + square_width/2, pos_y + square_height/2, false);
    
    draw_set_color(c_black);
    draw_rectangle(pos_x - square_width/2, pos_y - square_height/2, pos_x + square_width/2, pos_y + square_height/2, true);
    
    var y_up = pos_y - 55;
    draw_triangle(pos_x - 12, y_up + 4, pos_x + 12, y_up + 4, pos_x, y_up - 10, false);
    
    var y_down = pos_y + 55;
    draw_triangle(pos_x - 12, y_down - 4, pos_x + 12, y_down - 4, pos_x, y_down + 10, false);
    
    draw_set_color(c_white); 
    var digit_to_draw = (anim_offset[i] != 0) ? target_digits[i] : digits[i];
    draw_text(pos_x, pos_y + anim_offset[i], string(digit_to_draw));
    
    draw_set_color(c_black);
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);