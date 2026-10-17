required_item = ITEM_FRASCO
on_item_success = function(){
	scr_consume_item(ITEM_FRASCO)
	image_index = 0;
	image_speed = 1;
	image_index = image_number -1;
	image_speed = 0;
	scr_flag_set("chalice_filled")
}
on_interact = function(){
	if(scr_flag("chalice_filled")){
		dialog_lines = "";
		sprite_index = spr_painting_spilled_chalice;
		scr_flag_set("chalice_spilled")
	}
}

