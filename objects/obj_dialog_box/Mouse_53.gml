if (state == "typing"){
	var full_text = text_array[current_page];
	text_index = string_length(full_text);
	display_text = full_text;
	state = "waiting";
}
else if (state == "waiting"){
	current_page++;
	
	if (current_page < array_length(text_array)){
		text_index = 0;
		display_text = "";
		state = "typing";
	}
	else{
		state = "closing";
	}
} 