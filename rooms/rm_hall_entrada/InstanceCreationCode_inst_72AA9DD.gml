image_speed = 0;
dialog_lines = ["Encontre o pote que me satisfaça"];
speaker = "???"
text_color = c_red;

on_interact = function(){
	scr_flag_set("statue_inspected");
}
if(scr_flag("hotel_burned")){
sprite_index = spr_human_statue;
image_index = image_number - 1;
}

