function scr_add_directed_connection(from, to){
	var key = string(from)
	
	if(!variable_struct_exists(global.room_map, key)){
		variable_struct_set(global.room_map, key, [])	
	}
	
	var neighbors = variable_struct_get(global.room_map, key)
	array_push(neighbors, to)
}