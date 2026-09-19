switch(state){
	
	case "opening":
	box_alpha += fade_speed;
	if(box_alpha <= target_alpha){
		box_alpha = target_alpha;
		state = "typing";
	}
	break;
	
	case "typing":
	var full_text = text_array[current_page];
	if(text_index < string_length(full_text)){
		text_index += text_speed;
		display_text = string_copy(full_text, 1, floor(text_index));
	}
	else{
		state = "waiting";
	}
	break;
	
	case "closing":
	box_alpha -= fade_speed;
	if(box_alpha <= 0){
		instance_destroy();
	}
	break;
}