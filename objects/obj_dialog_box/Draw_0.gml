draw_set_alpha(box_alpha);
draw_set_color(c_black);
draw_roundrect_ext(box_x, box_y, box_x + box_width, box_y + box_height, 16, 16, false);

draw_set_alpha(box_alpha + 0.1); 
draw_set_color(c_white);
draw_roundrect_ext(box_x, box_y, box_x + box_width, box_y + box_height, 16, 16, true);

if (box_alpha > 0) {
    draw_set_alpha(box_alpha + 0.3); 
    draw_set_font(fnt_testes);
    
    var _padding_left = 24; 

    if (speaker != "") {
        draw_set_halign(fa_left); 
        draw_set_valign(fa_top);
        draw_set_color(c_white);
        
        draw_text(box_x + _padding_left, box_y + 16, speaker + ":");
    }

    draw_set_halign(fa_left); 
    draw_set_valign(fa_top);
    draw_set_color(color);
    
    var _padding_top = 42; 
    var _text_max_width = box_width - (_padding_left * 2);
    
    draw_text_ext(box_x + _padding_left, box_y + _padding_top, display_text, -1, _text_max_width);
}