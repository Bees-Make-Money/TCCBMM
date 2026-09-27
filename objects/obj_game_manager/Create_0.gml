global.previous_room = noone;
global.interaction_locked = false;
global.room_visits = {};

global.safe_solved = false;
global.iron_key_taken = false;
global.inventory_items = array_create(10, noone);
global.selected_inventory_slot = noone;
global.active_item_menu_buttons = [];
global.selected_item = "";

// Contadores do Puzzle 
global.engrenagens_colocadas = 0;
global.total_engrenagens = 3;

// Flags Booleanas
global.flags = {
    statue_inspected: false, 
    statue_solved: false,    
    library_unlocked: false,
    fiacao_consertada: false,
    maquina_ligada: false,
    lanterna_uv: false,
    chave_encontrada: false,
    porta_destrancada: false
};

scr_build_room_map();