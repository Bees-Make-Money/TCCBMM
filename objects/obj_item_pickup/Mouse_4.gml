if(global.interaction_locked) exit;

var added = scr_add_item_to_inventory(sprite_index, item_name);

if(added){
	window_set_cursor(cr_default)
	if (is_callable(on_pickup)) on_pickup();
	instance_destroy()
}

