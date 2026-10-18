if(global.interaction_locked) exit;

active = !active;
obj_room_change_button.can_click = !obj_flashlight.active;
obj_inventory_button.can_click = !obj_flashlight.active;
if(room == rm_varanda_superior && active && !scr_flag("golden_key_taken") && !instance_exists(obj_golden_key)){
	var numero = irandom_range(1, 5);
	instance_create_layer((112 * numero) + ((numero + 5) * numero), 350, "Instances", obj_golden_key);
}
else if(room == rm_corredor_superior && active && scr_flag("fish_taken") && !scr_flag("paintings_solved") && !instance_exists(obj_lore_paper_click)){
	instance_create_layer(room_width/2, 300, "Instances", obj_lore_paper_click);
}
else{
	if(instance_exists(obj_golden_key)){
		instance_destroy(obj_golden_key);	
	}
	if(instance_exists(obj_lore_paper_click)){
		instance_destroy(obj_lore_paper_click);
	}
}