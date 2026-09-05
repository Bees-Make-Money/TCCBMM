if (global.interaction_locked) exit;

if (instance_exists(obj_inventory_menu)){
	instance_destroy(obj_inventory_menu)
}
else {
	instance_create_layer(room_width/2, room_height/2, "Menu", obj_inventory_menu)
}