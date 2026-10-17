required_item = ITEM_MARTELO
if(scr_flag("chalice_spilled")){
	image_speed = 1;
	image_index = image_number - 1;
	scr_flag_set("aquarium_red")
	dialog_lines = ["Será que eu consigo libertá-lo de alguma forma?"];
	scr_show_dialog(["O que aconteceu?!", "A água do aquário ficou toda vermelha...", "O peixe ficou preso na água vermelha, coitado."])
}
on_item_success = function(){
	if(scr_flag("aquarium_red")){
		scr_consume_item(ITEM_MARTELO);
		scr_flag_set("aquarium_broken")
		sprite_index = spr_painting_aquarium_broken;
	}
	else{
		scr_show_dialog("Eu ainda não posso usar isso aqui.");
	}
}

on_interact = function(){
	if(scr_flag("aquarium_broken")){
		scr_add_item_to_inventory(ITEM_PEIXE)
		scr_flag_set("fish_taken");
		dialog_lines = "";
		sprite_index = spr_painting_aquarium_empty;
	}
}