for(var i = 0; i < array_length(option_buttons); i++){
	if(instance_exists(option_buttons[i])){
		instance_destroy(option_buttons[i])
	}
}