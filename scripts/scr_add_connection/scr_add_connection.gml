function scr_add_connection(room_a, room_b){
	scr_add_directed_connection(room_a, room_b)
	scr_add_directed_connection(room_b, room_a)
}