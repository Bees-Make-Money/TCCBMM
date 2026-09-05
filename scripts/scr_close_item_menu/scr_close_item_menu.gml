function scr_close_item_menu(){
	for (var i = 0; i < array_length(global.active_item_menu_buttons); i++){
		if(instance_exists(global.active_item_menu_buttons[i])){
			instance_destroy(global.active_item_menu_buttons[i])
		}
	}
	global.active_item_menu_buttons = []
}