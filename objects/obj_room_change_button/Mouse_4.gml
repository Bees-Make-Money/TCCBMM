if(global.interaction_locked) exit

if(instance_exists((obj_room_change_menu))){
	instance_destroy(obj_room_change_menu)
}
else{
	instance_create_layer(room_width/2, 200, "Menu", obj_room_change_menu)
}
