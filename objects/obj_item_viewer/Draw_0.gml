if (open_item == "") exit;

var _cx = room_width / 2;
var _cy = room_height / 2;

draw_set_alpha(view_a * 0.85);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(view_a);

// folha com cantos queimados
draw_set_color(make_color_rgb(222, 205, 160));
draw_rectangle(_cx - 170, _cy - 220, _cx + 170, _cy + 220, false);
draw_set_color(make_color_rgb(40, 22, 10));
draw_triangle(_cx - 170, _cy - 220, _cx - 110, _cy - 220, _cx - 170, _cy - 160, false);
draw_triangle(_cx + 170, _cy + 220, _cx + 110, _cy + 220, _cx + 170, _cy + 160, false);
draw_set_color(make_color_rgb(120, 90, 50));
draw_rectangle(_cx - 170, _cy - 220, _cx + 170, _cy + 220, true);

draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(make_color_rgb(70, 20, 15));

if (open_item == "Papel Chamuscado") {
    var _lab = variable_global_exists("fire_order_labels") ? global.fire_order_labels : ["?", "?", "?", "?"];
    draw_text_transformed(_cx, _cy - 150, "A ORDEM DO FOGO", 0.9, 0.9, 0);
    for (var i = 0; i < 4; i++) {
        draw_text_transformed(_cx - 120 + i * 80, _cy, _lab[i], 2.4, 2.4, 0);
    }
}
else {
    var _dg = variable_global_exists("mystery_digit") ? global.mystery_digit : "?";
    draw_text_transformed(_cx, _cy - 150, "UM NÚMERO", 0.9, 0.9, 0);
    draw_text_transformed(_cx, _cy, string(_dg), 5, 5, 0);
}

draw_set_color(make_color_rgb(110, 80, 50));
draw_text_transformed(_cx, _cy + 190, "clique para fechar", 0.6, 0.6, 0);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);