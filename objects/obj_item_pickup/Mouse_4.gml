if(global.interaction_locked) exit;

var added = scr_add_item_to_inventory(sprite_index, item_name);

if(added){
	instance_destroy()
}

