bg_layer_name = "Background";  
bg_state = -1;                   // 0 = normal, 1 = escura (incêndio), 2 = estante deslocada

// Primeira entrada na sala final: o inventário é esvaziado
if (!scr_flag("final_room_entered")) {
    scr_inventory_clear();
    scr_flag_set("final_room_entered");
}
// Troca o sprite do background conforme o estado
apply_background = function() {
    var _spr = spr_sala_final_normal;
    if (bg_state == 1){
		_spr = spr_sala_final_escura;
		instance_destroy(obj_livro_01);
		instance_destroy(obj_livro_06);
		instance_destroy(obj_livro_10);
		instance_destroy(obj_livro_21);
	}
    if (bg_state == 2) _spr = spr_sala_final_e_deslocada;

    var _layer = layer_get_id(bg_layer_name);
    if (_layer == -1) {
        show_debug_message("[FINAL] camada de background não encontrada: " + bg_layer_name);
        return;
    }
    layer_background_sprite(layer_background_get_id(_layer), _spr);
};

// ---- Sequência das auras ----
aura_objects = [obj_livro_06, obj_livro_21, obj_livro_10, obj_livro_01];   // ordem: 6, 21, 10, 1 (F, U, J, A)
wait_steps = 2 * game_get_speed(gamespeed_fps);      
gap_steps = 0.5 * game_get_speed(gamespeed_fps);    
seq_state = 0;       
seq_timer = 0;
seq_index = 0;
seq_wait_anim = false;
// Voltou à sala com o livro bizarro já liberado (aos 15 s) e ainda não pego: ele está no centro
if (scr_flag("weird_book_spawned") && !scr_flag("weird_book_taken")) scr_spawn_weird_book();