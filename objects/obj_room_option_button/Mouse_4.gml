var _can_enter = true;
var _locked_msg = [];

var _destino = target_room; 
var _key = string(_destino);

if (variable_struct_exists(global.room_locks, _key)) {
    var _lock_info = variable_struct_get(global.room_locks, _key);
    
    if (global.flags[$ _lock_info.req_flag] == false) {
        _can_enter = false;
        _locked_msg = [_lock_info.msg];
    }
}

if (_can_enter) {
    scr_change_room(_destino); 
} else {
    scr_show_dialog(_locked_msg, "Detetive", c_white);
}

if (instance_exists(obj_room_change_menu)) { 
    instance_destroy(obj_room_change_menu); 
}
instance_destroy();