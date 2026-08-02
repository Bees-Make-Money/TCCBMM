function scr_get_room_label(room_id){
	var key = string(room_id)
	
	if (variable_struct_exists(global.room_labels, key)){
		return variable_struct_get(global.room_labels, key)
	}
	return "Sala Desconhecida"
}