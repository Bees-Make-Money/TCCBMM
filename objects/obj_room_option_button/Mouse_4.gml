// Botão de ação (não troca de sala): fecha o menu e executa a função
if (is_callable(action)) {
    var _act = action;
    if (instance_exists(obj_room_change_menu)) instance_destroy(obj_room_change_menu);
    instance_destroy();
    _act();
    exit;
}

var _can_enter = true;
var _locked_msg = [];

var _destino = target_room;
var _key = string(_destino);

if (variable_struct_exists(global.room_locks, _key)) {
    var _lock_info = variable_struct_get(global.room_locks, _key);
    if (!scr_lock_allows(_lock_info)) {
        _can_enter = false;
        _locked_msg = [scr_lock_message(_lock_info)];
    }
}

if (instance_exists(obj_room_change_menu)) {
    instance_destroy(obj_room_change_menu);
}

if (_can_enter) {
    scr_change_room(_destino);
} else {
    scr_show_dialog(_locked_msg, "Detetive", c_white);
}

instance_destroy();