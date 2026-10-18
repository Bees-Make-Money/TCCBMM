function scr_add_item_to_inventory(sprite, name){
	for(var i = 0; i < array_length(global.inventory_items); i++){
		if(global.inventory_items[i] == noone){
			global.inventory_items[i] = {
				sprite: sprite,
				name: name
			}
			instance_create_layer(0, 0, "Text_Dialogs", obj_mensagem_inventario)
			obj_mensagem_inventario.msg_texto = $"O item " +  name + " foi adicionado ao inventário."
			return true
		}
	}
	return false
}