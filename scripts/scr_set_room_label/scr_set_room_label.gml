function scr_set_room_label(room_id, label){
	variable_struct_set(global.room_labels, string(room_id), label)
}