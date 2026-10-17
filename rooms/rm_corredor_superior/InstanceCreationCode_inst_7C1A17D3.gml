on_interact = function(){
	if(scr_flag("aquarium_red")){
		dialog_lines = "";
		scr_add_item_to_inventory(ITEM_MARTELO);
		scr_flag_set("hammer_taken");
	}
}