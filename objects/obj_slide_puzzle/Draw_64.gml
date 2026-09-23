var _gui_w = display_get_gui_width();
var _gui_h = display_get_gui_height();

draw_set_alpha(0.85);
draw_set_color(c_black);
draw_rectangle(0, 0, _gui_w, _gui_h, false);

if (alpha_pieces > 0) {
    draw_set_alpha(alpha_pieces);
    draw_set_color(c_white);
    
    var _ox = sprite_get_xoffset(spr_numbers_slide_puzzle);
    var _oy = sprite_get_yoffset(spr_numbers_slide_puzzle);

    for (var i = 0; i < 9; i++) {
        var _col = i mod 3;
        var _row = i div 3;
        
        var _px = pos_x_inicial + (_col * peca_tamanho);
        var _py = pos_y_inicial + (_row * peca_tamanho);
        
        var _valor = grid[i];
        
        if (_valor != 0) {
            draw_sprite(spr_numbers_slide_puzzle, _valor - 1, _px + _ox, _py + _oy); 
        }
    }
}
	
if (alpha_text > 0) {
    draw_set_alpha(alpha_text);
    
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    draw_text_transformed(_gui_w / 2, _gui_h / 2, "Test Drive...", 3, 3, 0); 
    
    var _bw = 80;
    var _bh = 50;
    var _bx = (_gui_w / 2) - (_bw / 2);
    var _by = (_gui_h / 2) + 120;
    
    draw_set_color(c_red);
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
    draw_set_color(c_white);
    
    draw_text_transformed(_bx + (_bw / 2), _by + (_bh / 2), "X", 1.5, 1.5, 0);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
} 

draw_set_alpha(1)