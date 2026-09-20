if (is_unselect) {
    global.selected_inventory_slot = noone; 
    
    global.selected_item = ""; 
    
} else {
    global.selected_inventory_slot = for_slot_index; 
    
    var _item_struct = global.inventory_items[for_slot_index];
    if (_item_struct != noone) {
        global.selected_item = _item_struct.name;
    }
}
scr_close_item_menu();