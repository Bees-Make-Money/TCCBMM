image_xscale = 12
image_yscale = 8

var _options = scr_get_available_rooms();
back_option = _options.back;
forward_options = _options.forward;

option_buttons = [];

var _has_back = (back_option != noone);

// Declaração prévia para evitar o erro de escopo (GM2043)
var _forward_start_y = 0;
back_title_y    = y - 90;
forward_title_y = y - 10;

if (_has_back) {
    var _back_y  = y - 60;
    
    var _btn_back = instance_create_layer(x, _back_y, "Menu", obj_room_option_button);
    _btn_back.target_room = back_option.target;
    _btn_back.room_label  = back_option.label;
    array_push(option_buttons, _btn_back);
    
    forward_title_y  = y - 10;
    _forward_start_y = y + 20;
} else {
    forward_title_y  = y - 80;
    _forward_start_y = y - 45;
}

var _total     = array_length(forward_options);
var _spacing_y = 40; 

for (var i = 0; i < _total; i++) {
    var _data  = forward_options[i];
    var _btn_y = _forward_start_y + (i * _spacing_y);

    var _btn = instance_create_layer(x, _btn_y, "Menu", obj_room_option_button);
    _btn.target_room = _data.target;
    _btn.room_label  = _data.label;
    array_push(option_buttons, _btn);
}
