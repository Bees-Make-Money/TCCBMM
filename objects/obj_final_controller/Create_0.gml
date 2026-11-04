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