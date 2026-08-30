function scr_increment_room_visits(room_id){
	var current_visits = scr_get_room_visits(room_id);
    variable_struct_set(global.room_visits, string(room_id), current_visits + 1);
}