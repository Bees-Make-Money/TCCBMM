if (is_unselect) {
    global.selected_inventory_slot = noone;
} else {
    global.selected_inventory_slot = for_slot_index;
}
scr_close_item_menu();