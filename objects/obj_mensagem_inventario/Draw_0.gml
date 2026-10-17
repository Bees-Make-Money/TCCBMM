if (msg_ativada && msg_alpha > 0) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var _x = 816 / 2; 
    var _y = 460;     
    
    draw_set_alpha(msg_alpha);
    draw_set_color(c_black);
    
    draw_text(_x + 2, _y + 2, msg_texto);
    draw_text(_x - 2, _y + 2, msg_texto);
    draw_text(_x + 2, _y - 2, msg_texto);
    draw_text(_x - 2, _y - 2, msg_texto);
    
    draw_set_color(c_white);
    draw_text(_x, _y, msg_texto);
    
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}