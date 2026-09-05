scr_increment_room_visits(room)

if(room != rm_interface && room != rm_creditos){
	if(instance_exists(obj_room_change_button)){
		instance_destroy(obj_room_change_button)
	}
	instance_create_layer(144, 528, "Buttons", obj_room_change_button)
	instance_create_layer(300, 528, "Buttons", obj_inventory_button)
}
