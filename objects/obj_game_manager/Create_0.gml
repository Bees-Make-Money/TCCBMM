if (instance_number(obj_game_manager) > 1) {
    instance_destroy();
    exit;
}
window_set_fullscreen(true)
display_set_gui_size(display_get_width(), display_get_height())

global.previous_room = noone
global.interaction_locked = false
global.room_visits = {}
global.safe_solved = false
global.inventory_items = array_create(10, noone)
global.selected_inventory_slot = noone
global.active_item_menu_buttons = []
global.iron_key_taken = false
global.selected_item = "";
scr_build_room_map()

global.flags = {
    statue_inspected: false, 
    statue_solved: false,    
    library_unlocked: false,
	slide_puzzle_solved: false
};

global.room_locks = {};
variable_struct_set(global.room_locks, string(rm_varanda_superior), {
    req_flag: "statue_solved", 
    msg: "Devo terminar de resolver esta sala antes de subir"
});
variable_struct_set(global.room_locks, string(rm_biblioteca), {
    req_flag: "library_unlocked", 
    msg: "A porta desta sala está trancada... como posso abrí-la?"
});

