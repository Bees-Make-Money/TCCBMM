//testes para facilitar o desenvolvimento
if (DEBUG_MODE) {
    //vai para a próxima sala da lista de debug (com fade)
    if (keyboard_check_pressed(vk_f4)) {
        var _rooms = scr_debug_rooms();
        global.debug_room_index = (global.debug_room_index + 1) mod array_length(_rooms);
        scr_change_room(_rooms[global.debug_room_index]);
    }
	//desliga a escuridão do labirinto
	if (keyboard_check_pressed(vk_f6)) {
        global.debug_light_off = !global.debug_light_off;
    }
	if(keyboard_check_pressed(vk_f8)){
		if(instance_exists(obj_dark_key)){
			instance_destroy(obj_dark_key);
		}
		instance_create_layer(300, 300, "Instances", obj_dark_key);
	}
	    // Home: incêndio + contagem de 30 s (pula o painel) | End: coloca a contagem em 16 s 
    if (keyboard_check_pressed(vk_home)) {
        scr_flag_set("hotel_burned");
        scr_final_countdown_start();
    }
    if (keyboard_check_pressed(vk_end)) {
        global.final_timer = 16 * game_get_speed(gamespeed_fps);
    }
 }