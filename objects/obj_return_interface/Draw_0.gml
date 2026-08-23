var _cor_normal = make_color_rgb(200, 200, 200);
var _cor_hover = c_white;
var _cor_atual = _cor_normal;

var _mouse_sobre = point_in_rectangle(mouse_x, mouse_y, x, y, x + largura, y + altura);

if (_mouse_sobre) {
    _cor_atual = _cor_hover;
}

var _cx = x + largura / 2;
var _cy = y + altura / 2;
draw_set_color(_cor_atual);
draw_line_width(_cx - tamanho_seta / 2, _cy, _cx + tamanho_seta / 2, _cy, espessura_linha);
var _ponta_x = _cx - tamanho_seta / 2;
draw_triangle(
    _ponta_x - 8, _cy,              
    _ponta_x + 8, _cy - 8,         
    _ponta_x + 8, _cy + 8,       
    false
);