if (global.interaction_locked) exit;

    
    if (global.selected_item == "Lente" && !global.lens_attached) {
        scr_remove_item_from_inventory("Lente");
        global.selected_item = "";
        global.selected_inventory_slot = noone;
        global.lens_attached = true;
    }
