if(global.interaction_locked) exit;

var added = scr_add_item_to_inventory(sprite_index, item_name);

if(added){
	window_set_cursor(cr_default)
	if (instance_exists(obj_lightning_pot)) instance_destroy(obj_lightning_pot);
    if (instance_exists(obj_zelda_pot)) instance_destroy(obj_zelda_pot);
	
	instance_destroy()
}