function scr_add_item_to_inventory(sprite, name){
	for(var i = 0; i < array_length(global.inventory_items); i++){
		var _reserved = variable_global_exists("inventory_reserved") ? global.inventory_reserved[i] : false;
		if(global.inventory_items[i] == noone && !_reserved){
			global.inventory_items[i] = {
				sprite: sprite,
				name: name
			}
			return true
		}
	}
	return false
}