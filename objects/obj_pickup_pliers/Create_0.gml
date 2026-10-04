 event_inherited();

    item_name = "Alicate";

    custom_click = function() {
        if (scr_add_item_to_inventory(sprite_index, item_name)) {
            instance_destroy();
        }
    }

