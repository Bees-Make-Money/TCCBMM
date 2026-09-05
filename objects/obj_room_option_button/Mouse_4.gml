if(global.interaction_locked && !(instance_exists(obj_room_change_menu))) exit

if(target_room != noone){
	scr_change_room(target_room)
}