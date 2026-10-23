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
 }