if (solved) exit;
if (global.interaction_locked) exit

if (!instance_exists(obj_safe_menu)){
	var inst = instance_create_layer(room_width/2, room_height/2 - 100, "Menu", obj_safe_menu)
	inst.safe_origin = id
}