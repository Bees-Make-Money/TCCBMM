//draw aqui feito com IA, 0 condição de fazer na mão.

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// Fundo Preto
draw_set_alpha(alpha_fundo);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);

// Texto Vermelho
draw_set_alpha(1);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_red);

draw_text_transformed(_gw / 2, _gh / 2 - 120, texto_exibido, 4, 4, 0);

// Botão de Reiniciar
if (mostrar_botao) {
    var _bw = 500; // Largura do botão (antes era 260)
    var _bh = 100; // Altura do botão (antes era 60)
    
    var _bx = (_gw / 2) - (_bw / 2);
    var _by = (_gh / 2) + 120;
    
    draw_set_color(c_maroon); 
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
    
    draw_set_color(c_white);
    draw_text_transformed(_bx + (_bw / 2), _by + (_bh / 2), "Tentar Novamente", 2.5, 2.5, 0);
    
    // Verificação de Clique no Botão
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    
    if (mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(_mx, _my, _bx, _by, _bx + _bw, _by + _bh)) {
            game_restart();
        }
    }
}

// Reseta o alinhamento de texto para evitar bugs
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
