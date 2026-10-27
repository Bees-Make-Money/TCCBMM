if (current == "") exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

// Retângulo (em pixels da janela) onde a GUI/jogo realmente aparece
var _p = application_get_position();      // [x1, y1, x2, y2]
var _area_w = _p[2] - _p[0];
var _area_h = _p[3] - _p[1];
var _bar    = _p[0];                      // largura da faixa preta esquerda, em pixels

// Faixa útil? (descontando margem dos dois lados)
var _w = _bar - margin * 2;
if (_w < 80) exit;

// Fator que converte pixels da tela -> unidades da GUI (desfaz o esticamento)
var _sx = _gw / _area_w;
var _sy = _gh / _area_h;
matrix_set(matrix_world, matrix_build(0, 0, 0, 0, 0, 0, _sx, _sy, 1));

// A partir daqui, tudo é em PIXELS REAIS. x = 0 é a borda esquerda da cena,
// então a faixa preta esquerda vai de x = -_bar até x = 0.
var _h  = _w * aspect;
var _x1 = -_bar + margin;
var _y1 = margin;
var _x2 = _x1 + _w;
var _y2 = _y1 + _h;
var _pad = 16;

// Fundo e contorno
draw_set_alpha(box_alpha);
draw_set_color(c_black);
draw_roundrect_ext(_x1, _y1, _x2, _y2, 16, 16, false);

draw_set_alpha(box_alpha + 0.1);
draw_set_color(c_white);
draw_roundrect_ext(_x1, _y1, _x2, _y2, 16, 16, true);

// Título
draw_set_font(fnt_testes);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(box_alpha + 0.3);
draw_text_transformed(_x1 + _pad, _y1 + _pad, "Objetivo", text_scale, text_scale, 0);

// Linha separadora
var _line_y = _y1 + _pad + string_height("Objetivo") * text_scale + 8;
draw_line(_x1 + _pad, _line_y, _x2 - _pad, _line_y);

// Objetivo atual, com quebra automática
draw_set_alpha(text_alpha);
draw_text_ext_transformed(_x1 + _pad, _line_y + 12, current, -1, (_w - _pad * 2) / text_scale, text_scale, text_scale, 0);

// Restaura o estado (inclusive a matriz, senão os outros GUIs quebram)
matrix_set(matrix_world, matrix_build_identity());
draw_set_alpha(1);
draw_set_color(c_white);