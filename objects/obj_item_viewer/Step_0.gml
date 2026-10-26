var _sel = global.selected_item;

if (open_item == "") {
    if (_sel != last_sel) dismissed = "";
    if ((_sel == "Papel Chamuscado" || _sel == "Papel Misterioso") && _sel != dismissed
        && !instance_exists(obj_inventory_menu) && !instance_exists(obj_dialog_box) && !global.interaction_locked) {
        open_item = _sel;
        view_a = 0;
        scr_lock();
        locked_by_me = true;
    }
}
else {
    view_a = min(1, view_a + 0.1);
    if (view_a >= 1 && mouse_check_button_pressed(mb_left)) {
        dismissed = open_item;
        open_item = "";
        if (locked_by_me) { scr_unlock(); locked_by_me = false; }
        global.selected_item = "";
        global.selected_inventory_slot = noone;
    }
}
last_sel = _sel;