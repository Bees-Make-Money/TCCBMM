//testes para facilitar o desenvolvimento
if (DEBUG_MODE) {
    // mostra o estado atual
    if (keyboard_check_pressed(vk_f1)) {
        show_debug_message("[DEBUG] sala: " + room_get_name(room) + " | locks: " + string(global.lock_count));
        show_debug_message("[DEBUG] flags: " + json_stringify(global.flags));
    }
    // avança um estágio do puzzle dos quadros
    if (keyboard_check_pressed(vk_f2)) {
        var _max = array_length(scr_debug_paintings_flags());
        scr_debug_set_paintings_stage(min(global.debug_stage + 1, _max));
    }
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
	if (keyboard_check_pressed(vk_pageup)) {
        var _maxf = array_length(scr_debug_final_flags());
        scr_debug_set_final_stage(min(global.debug_final_stage + 1, _maxf));
    }
    if (keyboard_check_pressed(vk_pagedown)) {
        scr_debug_set_final_stage(0);
    }
	    // Home: incêndio + contagem de 30 s (pula o painel) | End: coloca a contagem em 16 s (testa o livro bizarro)
    if (keyboard_check_pressed(vk_home)) {
        scr_flag_set("hotel_burned");
        scr_final_countdown_start();
    }
    if (keyboard_check_pressed(vk_end)) {
        global.final_timer = 16 * game_get_speed(gamespeed_fps);
    }
	    // Delete: dispara a cena do final 1 direto (teste)
    if (keyboard_check_pressed(vk_delete)) {
        scr_start_ending(1);
    }
	    // Insert: coloca no inventário os livros do puzzle final que ainda não foram pegos (teste)
    if (keyboard_check_pressed(vk_insert)) {
        var _ids = [2, 7, 11, 18, 25];
        for (var i = 0; i < 5; i++) {
            var _nm = scr_book_item_name(_ids[i]);
            if (scr_inventory_find(_nm) == -1 && !scr_flag("book_" + string(_ids[i]) + "_taken")) {
                scr_add_item_to_inventory(scr_book_icon(_ids[i]), _nm);
                scr_flag_set("book_" + string(_ids[i]) + "_taken");
            }
        }
    }
 }