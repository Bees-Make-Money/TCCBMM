function scr_change_room(target_room){
	if(target_room == room) return
	
	global.previous_room = room;
	room_goto(target_room)
}