if (instance_number(obj_game_manager) > 1) {
    instance_destroy();
    exit;
}
randomize();
window_set_fullscreen(true)
display_set_gui_size(display_get_width(), display_get_height())

global.previous_room = noone
global.interaction_locked = false
global.lock_count = 0;
global.room_visits = {}
global.inventory_items = array_create(10, noone)
global.selected_inventory_slot = noone
global.active_item_menu_buttons = []
global.selected_item = "";
scr_build_room_map()

global.flags = {
    // Puzzle 1 - Estátua (Sclebin)
    statue_inspected: false,
    slide_puzzle_solved: false,
    pot_chosen: false,
    statue_solved: false,

    // Puzzle 2 - Quadros (Sclebin)


    // Puzzles 3 a 5 (Salas Puzzle - Guimarães)

    // Puzzle 6 - Cofre
    safe_solved: false,
    iron_key_taken: false,

    // Puzzle 7 - Biblioteca
    library_unlocked: false
};

global.room_locks = {};
variable_struct_set(global.room_locks, string(rm_varanda_superior), {
    req_flag: "statue_solved", 
    msg: "Devo terminar de resolver esta sala antes de subir"
});
variable_struct_set(global.room_locks, string(rm_sala_final), {
    req_flag: "endroom_unlocked", 
    msg: "A porta desta sala está trancada... como posso abrí-la?"
});

