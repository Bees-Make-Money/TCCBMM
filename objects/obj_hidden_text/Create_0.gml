visible = false;   // nunca se desenha sozinho: quem desenha é o obj_uv_light

if (!variable_instance_exists(id, "hidden_text")) hidden_text = "?";
if (!variable_instance_exists(id, "text_scale"))  text_scale  = 1;

// cores "fluorescentes"
text_col = make_color_rgb(205, 160, 255);
glow_col = make_color_rgb(120, 60, 230);

// separa as linhas (|)
hidden_lines = [];
var _rest = hidden_text;
while (true) {
    var _p = string_pos("|", _rest);
    if (_p == 0) {
        array_push(hidden_lines, _rest);
        break;
    }
    array_push(hidden_lines, string_copy(_rest, 1, _p - 1));
    _rest = string_delete(_rest, 1, _p);
}

// tamanho do texto
draw_set_font(fnt_testes);
line_h = string_height("A") * text_scale;
text_w = 0;
for (var i = 0; i < array_length(hidden_lines); i++) {
    text_w = max(text_w, string_width(hidden_lines[i]) * text_scale);
}
text_h = line_h * array_length(hidden_lines);

// desenha o texto SÓ perto da luz, letra por letra, com brilho
draw_hidden = function(_lx, _ly, _radius) {
    // luz longe demais do texto: nada a fazer
    var _nx = clamp(_lx, x, x + text_w);
    var _ny = clamp(_ly, y, y + text_h);
    if (point_distance(_lx, _ly, _nx, _ny) > _radius) return;

    draw_set_font(fnt_testes);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    for (var l = 0; l < array_length(hidden_lines); l++) {
        var _line = hidden_lines[l];
        var _cx   = x;
        var _cy   = y + l * line_h;

        for (var c = 1; c <= string_length(_line); c++) {
            var _ch = string_char_at(_line, c);
            var _cw = string_width(_ch) * text_scale;
            var _d  = point_distance(_lx, _ly, _cx + _cw / 2, _cy + line_h / 2);
            var _a  = clamp(1 - (_d / _radius), 0, 1);
            _a = min(1, _a * 1.8);

            if (_a > 0) {
                draw_set_color(glow_col);
                draw_set_alpha(_a * 0.45);
                draw_text_transformed(_cx - 1, _cy, _ch, text_scale, text_scale, 0);
                draw_text_transformed(_cx + 1, _cy, _ch, text_scale, text_scale, 0);
                draw_text_transformed(_cx, _cy - 1, _ch, text_scale, text_scale, 0);
                draw_text_transformed(_cx, _cy + 1, _ch, text_scale, text_scale, 0);

                draw_set_color(text_col);
                draw_set_alpha(_a);
                draw_text_transformed(_cx, _cy, _ch, text_scale, text_scale, 0);
            }
            _cx += _cw;
        }
    }
    draw_set_alpha(1);
}
