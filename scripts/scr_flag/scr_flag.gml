function scr_flag(name){
	if(!variable_struct_exists(global.flags, name)){
		show_debug_message("[FLAG] Uma flag inexistente tentou ser lida: " + string(name));
		return false;
	}
	return global.flags[$ name]
}

function scr_flag_set(name, value = true){
	if(!variable_struct_exists(global.flags, name)){
		show_debug_message("[FLAG] Uma flag inexistente tentou ser modificada: " + string(name) + " (declare no obj_game_manager)");
	}
	global.flags[$ name] = value;
}