draw_self();

var _item = global.inventory_items[slot_index];

if (_item != noone) {
    draw_sprite(_item.sprite, 0, x, y);
}

if (global.selected_inventory_slot == slot_index) {
    var _hue = (current_time / 5) mod 255;
    var _color = make_color_hsv(_hue, 220, 255);
    
    draw_set_color(_color);
    
    draw_rectangle(x - 46, y - 46, x + 46, y + 46, true);
    draw_rectangle(x - 41, y - 41, x + 41, y + 41, true);
    draw_rectangle(x - 40, y - 40, x + 40, y + 40, true);
    
    draw_set_color(c_white);
}