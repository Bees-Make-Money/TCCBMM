//é um script de testes, para evitar erros uma vez que o projeto está ficando grande.
#macro DEBUG_MODE true

/// Flags do puzzle dos quadros, na ordem em que acontecem.
function scr_debug_paintings_flags() {
    return [
        "golden_key_taken",
        "corridor_door_unlocked",
        "flask_taken",
        "meeting_papers_cleared",
        "chalice_filled",
        "chalice_spilled",
        "aquarium_red",
        "hammer_taken",
        "aquarium_broken",
        "fish_taken",
        "hunger_paper_read",
        "paintings_solved",
		"chapter2_shown"
    ];
}

/// Salas pelas quais a tecla F4 passa.
function scr_debug_rooms() {
    return [rm_hall_entrada, rm_varanda_superior,
            rm_corredor_superior, rm_sala_reunioes, rm_labirinto_1, rm_labirinto_2, rm_sala_negocios_1];
}
/// Liga as primeiras _n flags da lista e desliga as demais.
function scr_debug_set_paintings_stage(_n) {
    var _list = scr_debug_paintings_flags();
    for (var i = 0; i < array_length(_list); i++) {
        scr_flag_set(_list[i], i < _n);
    }
    global.debug_stage = _n;
    show_debug_message("[DEBUG] estágio do puzzle dos quadros: " + string(_n) + "/" + string(array_length(_list)));
}