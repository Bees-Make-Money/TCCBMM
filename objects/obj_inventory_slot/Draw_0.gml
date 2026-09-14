draw_self();

var _item = global.inventory_items[slot_index];

if (_item != noone) {
    draw_sprite(_item.sprite, 0, x, y);
}

if (global.selected_inventory_slot == slot_index) {
    var color_cyan   = make_color_rgb(0, 230, 180);
    var color_blue   = make_color_rgb(0, 90, 255);
    var color_purple = make_color_rgb(180, 0, 255);
    var color_orange = make_color_rgb(255, 110, 0);
    var color_red    = make_color_rgb(255, 20, 30);

    var _t = (sin(current_time * 0.001) + 1) / 2;
    var _color;

    if (_t < 0.25) {
        _color = merge_color(color_cyan, color_blue, _t * 4);
    } else if (_t < 0.50) {
        _color = merge_color(color_blue, color_purple, (_t - 0.25) * 4);
    } else if (_t < 0.75) {
        _color = merge_color(color_purple, color_orange, (_t - 0.50) * 4);
    } else {
        _color = merge_color(color_orange, color_red, (_t - 0.75) * 4);
    }

    draw_set_color(_color);
	draw_set_alpha(0.6);
    var _offset = 50;
    var _espessura = 4;

    for (var i = 0; i < _espessura; i++) {
        draw_rectangle(x - (_offset - i), y - (_offset - i), x + (_offset - i), y + (_offset - i), true);
    };

	draw_set_alpha(1);
    draw_set_color(c_white);
	draw_set_alpha(1);
}