function scr_change_room(target_room, _force = false) {
    if (target_room == room && !_force) return;

    if (!instance_exists(obj_fade)) {
        var _fade = instance_create_depth(0, 0, -9999, obj_fade);
        _fade.target_room = target_room;
    }
}