function scr_change_room(target_room) {
    if (target_room == room) return;
	
    if (!instance_exists(obj_fade)) {
        var _fade = instance_create_depth(0, 0, -9999, obj_fade); 
        _fade.target_room = target_room;
    }
}