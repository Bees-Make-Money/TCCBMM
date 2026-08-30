function scr_get_room_visits(room_id){
	var key = string(room_id);

    if (variable_struct_exists(global.room_visits, key)) {
        return variable_struct_get(global.room_visits, key);
    }

    return 0;
}