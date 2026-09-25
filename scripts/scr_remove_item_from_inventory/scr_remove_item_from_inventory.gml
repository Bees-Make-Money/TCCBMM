function scr_remove_item_from_inventory(_nome_do_item) {
    for (var i = 0; i < array_length(global.inventory_items); i++) {
        var _item = global.inventory_items[i];
        
        if (_item != noone && _item.name == _nome_do_item) {
            global.inventory_items[i] = noone;
            return true;
        }
    }
    return false;
}