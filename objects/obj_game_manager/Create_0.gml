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
global.debug_stage = 0;
global.debug_room_index = -1
global.debug_light_off = false
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
	golden_key_taken: false,
    corridor_door_unlocked: false,
	meeting_papers_read: false,
    flask_taken: false,
    meeting_papers_cleared: false,
    chalice_filled: false,
    chalice_spilled: false,
    aquarium_red: false,
    hammer_taken: false,
    aquarium_broken: false,
    fish_taken: false,
    hunger_paper_read: false,
    paintings_solved: false,
    chapter2_shown: false,

    // Puzzles 3 a 5 (Salas Puzzle - Guimarães)
	
	//Sala de Negócios 1
	
	
	
	//Sala de negócios 2
	gear_large_taken  : false,
	gear_medium_taken : false,
	gear_small_taken  : false,
	pliers_taken      : false,
	gear_large_placed  : false,
	gear_medium_placed : false,
	gear_small_placed  : false,
	gear_panel_solved  : false,
	wiring_fixed        : false, 
	negocios_3_unlocked : false,
	
	//Sala de negócios 3
	console_taken        : false,
	controller_taken     : false,
	tv_on                : false,
	console_connected    : false,
	controller_connected : false,
	penalty_won          : false,
	paper_digit_taken    : false,
	uv_lens_acquired     : false,
	
	//Sala do cofre
	bucket_taken      : false,
	fire_solved       : false,
	order_paper_taken : false,
    endroom_unlocked  : false,

	
	

    // Puzzle 6 - Cofre
    safe_solved: false,
    iron_key_taken: false,

    // Puzzle 7 - Biblioteca
    library_unlocked: false
	
	



};

global.room_locks = {};
variable_struct_set(global.room_locks, string(rm_varanda_superior), {
    req_flag: "statue_solved", 
    msg: "Devo terminar de resolver este andar antes de subir"
});
variable_struct_set(global.room_locks, string(rm_sala_final), {
    req_flag: "endroom_unlocked", 
    msg: "A porta desta sala está trancada... como posso abrí-la?"
});
variable_struct_set(global.room_locks, string (rm_sala_reunioes), {
	req_flag: "corridor_door_unlocked",
	msg: "Essa porta está trancada. Talvez alguma chave secreta a libere?"
});
variable_struct_set(global.room_locks, string(rm_sala_negocios_1), {
    req_flag: "paintings_solved",
    msg: "A porta não abre. Algo não quer que eu passe."
});
variable_struct_set(global.room_locks, string(rm_sala_negocios_3), {
    req_flag: "negocios_3_unlocked",
    msg: "A porta está trancada. O painel ao lado parece controlar a fechadura."
});

instance_create_depth(0, 0, -8, obj_uv_light);

