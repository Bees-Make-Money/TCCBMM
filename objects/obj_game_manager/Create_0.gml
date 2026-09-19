if (instance_number(obj_game_manager) > 1) {
    instance_destroy();
    exit;
}

global.previous_room = noone
global.interaction_locked = false
global.room_visits = {}
global.safe_solved = false
global.inventory_items = array_create(10, noone)
global.selected_inventory_slot = noone
global.active_item_menu_buttons = []
global.iron_key_taken = false
scr_build_room_map()

window_set_fullscreen(true)
display_set_gui_size(display_get_width(), display_get_height())
