function scr_room_has_hud(_room){
	if (_room == rm_interface)   return false;
    if (_room == rm_creditos)    return false;
    if (_room == rm_labirinto_1) return false;
    if (_room == rm_labirinto_2) return false;
    return true;
}