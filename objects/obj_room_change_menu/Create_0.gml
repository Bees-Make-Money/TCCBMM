image_xscale = 12;
image_yscale = 8;
depth = 10;

global.interaction_locked = true;

var _options = scr_get_available_rooms();
back_option = _options.back;
forward_options = _options.forward;
option_buttons = [];

forward_title_y = bbox_top + 40;

var _total = array_length(forward_options);
var _spacing_y = 50;
var _forward_start_y = forward_title_y + 60;

for (var i = 0; i < _total; i++) {
    var _data = forward_options[i];
    
    var _btn_x = x;
    var _btn_y = _forward_start_y + (i * _spacing_y);
    
    var _btn = instance_create_layer(_btn_x, _btn_y, "Menu", obj_room_option_button);
    _btn.target_room = _data.target;
    _btn.room_label  = _data.label;
    _btn.depth = depth - 10;
    
    array_push(option_buttons, _btn);
}

if (back_option != noone) {
    var _back_x = bbox_left + 20;
    var _back_y = bbox_bottom - 30;
    
    var _btn_back = instance_create_layer(_back_x, _back_y, "Menu", obj_room_option_button);
    _btn_back.target_room = back_option.target;
    _btn_back.room_label  = "Retornar para: " + back_option.label;
    _btn_back.is_back_btn = true;
    _btn_back.depth = depth - 10;
    
    array_push(option_buttons, _btn_back);
}
