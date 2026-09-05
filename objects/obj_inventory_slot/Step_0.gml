if (mouse_check_button_pressed(mb_left)) {
    if (position_meeting(mouse_x, mouse_y, id)) {
        if (global.inventory_items[slot_index] == noone) exit; 

        if (array_length(global.active_item_menu_buttons) > 0) {
            scr_close_item_menu();
            exit;
        }

        scr_close_item_menu();

        var _opt_select = instance_create_layer(x, y + 50, "Menu", obj_inventory_option_select);
        _opt_select.for_slot_index = slot_index;

        if (global.selected_inventory_slot == slot_index) {
            _opt_select.button_text = "Cancelar Seleção";
            _opt_select.is_unselect = true;
        } else {
            _opt_select.button_text = "Selecionar";
            _opt_select.is_unselect = false;
        }

        var _opt_cancel = instance_create_layer(x, y + 80, "Menu", obj_inventory_option_cancel);
        _opt_cancel.for_slot_index = slot_index;

        global.active_item_menu_buttons = [_opt_select, _opt_cancel];
    }
}