function scr_add_item_to_inventory(sprite, name){
	for(var i = 0; i < array_length(global.inventory_items); i++){
		if(global.inventory_items[i] == noone){
			global.inventory_items[i] = {
				sprite: sprite,
				name: name
			}
			return true
		}
	}
	return false
}