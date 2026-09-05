global.interaction_locked = false;

scr_close_item_menu();

for (var i = 0; i < array_length(slot_instances); i++) {
    if (instance_exists(slot_instances[i])) {
        instance_destroy(slot_instances[i]);
    }
}