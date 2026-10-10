if(global.interaction_locked) exit;

active = !active;
obj_room_change_button.can_click = !obj_flashlight.active;
obj_inventory_button.can_click = !obj_flashlight.active;
if(room == rm_varanda_superior && active && !scr_flag("golden_key_taken") && !instance_exists(obj_golden_key)){
	var numero = irandom_range(1, 5);
	instance_create_layer((112 * numero) + ((numero + 5) * numero), 350, "Instances", obj_golden_key);
}
else{
	instance_destroy(obj_golden_key);
}