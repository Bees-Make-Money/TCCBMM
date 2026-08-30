draw_set_alpha(0.8)
draw_set_colour(c_black)
draw_rectangle(0, 0, room_width, room_height, false)

var tempo = current_time * 0.002;
var tom_azul = 80 + sin(tempo) * 35;

var cor_topo = make_color_rgb(15, 20, 35);
var cor_centro = make_color_rgb(30, 40, floor(tom_azul));
var cor_borda = make_color_rgb(200, 210, 230);

var menu_w = 520;
var menu_h = 340;
var x1 = x - (menu_w / 2);
var y1 = y - (menu_h / 2);
var x2 = x + (menu_w / 2);
var y2 = y + (menu_h / 2);

draw_set_color(c_black);
draw_set_alpha(0.4);
draw_rectangle(x1 + 8, y1 + 8, x2 + 8, y2 + 8, false);
draw_set_alpha(1.0); 

draw_rectangle_color(x1, y1, x2, y2, cor_topo, cor_topo, cor_centro, cor_centro, false);

draw_set_color(cor_borda);
draw_rectangle(x1, y1, x2, y2, true);

draw_set_color(c_black);
draw_rectangle(x1 + 3, y1 + 3, x2 - 3, y2 - 3, true);

draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

for (var i = 0; i < 4; i++) {
    var pos_x = start_x + i * (square_width + spacing);
    var pos_y = start_y;
    
    draw_set_color(make_color_rgb(10, 12, 18));
    draw_rectangle(pos_x - square_width/2, pos_y - square_height/2, pos_x + square_width/2, pos_y + square_height/2, false);
    
    draw_set_color(cor_borda);
    draw_rectangle(pos_x - square_width/2, pos_y - square_height/2, pos_x + square_width/2, pos_y + square_height/2, true);
    
    var y_up = pos_y - 70;
    draw_set_color(cor_borda);
    draw_triangle(pos_x - 14, y_up + 10, pos_x + 14, y_up + 10, pos_x, y_up - 12, false);
    
    var y_down = pos_y + 70;
    draw_triangle(pos_x - 14, y_down - 10, pos_x + 14, y_down - 10, pos_x, y_down + 12, false);
    
    draw_set_color(c_white);
    var digit_to_draw = (anim_offset[i] != 0) ? target_digits[i] : digits[i];
    draw_text(pos_x, pos_y + anim_offset[i], string(digit_to_draw));
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);