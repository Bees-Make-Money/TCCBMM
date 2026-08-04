if(instance_exists(obj_room_change_button)){
 instance_destroy(obj_room_change_button)
}

instance_create_layer(144, 528, "Menu", obj_room_change_button)