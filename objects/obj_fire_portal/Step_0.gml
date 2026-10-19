// depois que o diálogo é fechado, entra no flashback
if (pending && !instance_exists(obj_dialog_box)) {
    pending = false;
    window_set_cursor(cr_default);
    var _f = instance_create_depth(0, 0, -9998, obj_fade);
    _f.target_room = rm_incendio;
}
