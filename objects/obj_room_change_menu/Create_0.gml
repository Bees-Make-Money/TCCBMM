image_xscale = 12;
image_yscale = 8;
depth = 10; 

global.interaction_locked = true;

var _options = scr_get_available_rooms();
var _back_option = _options.back;
var _forward_options = _options.forward;
option_buttons = [];

menu_title_y = bbox_top + 40;

var _start_y = menu_title_y + 60;
var _spacing_y = 45;
var _current_index = 0;


var _total_forward = array_length(_forward_options);
for (var i = 0; i < _total_forward; i++) {
    var _data = _forward_options[i];
    
    var _btn_y = _start_y + (_current_index * _spacing_y);
    var _btn = instance_create_layer(x, _btn_y, "Menu", obj_room_option_button);
    
    _btn.target_room = _data.target;
    _btn.room_label  = "Ir para " + _data.label; 
    _btn.depth = depth - 10;
    
    array_push(option_buttons, _btn);
    _current_index++;
}

if (_back_option != noone) {
    var _btn_y = _start_y + (_current_index * _spacing_y);
    var _btn = instance_create_layer(x, _btn_y, "Menu", obj_room_option_button);
    
    _btn.target_room = _back_option.target;
    _btn.room_label  = "De onde vim: " + _back_option.label; 
    _btn.depth = depth - 10;
    
    array_push(option_buttons, _btn);
    _current_index++;
}