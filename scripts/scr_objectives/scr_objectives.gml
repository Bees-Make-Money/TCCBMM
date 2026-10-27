/// _done = nome de uma flag (string) OU uma função que devolve true quando o objetivo foi concluído.
/// _when = função que devolve true quando o objetivo já pode aparecer.
function scr_objective_add(_text, _done, _when = -1) {
    array_push(global.objectives, { text: _text, done: _done, when: _when, warned: false });
}

function scr_objective_is_done(_o) {
    if (is_string(_o.done)) {
        if (!variable_struct_exists(global.flags, _o.done)) {
            if (!_o.warned) {                      // avisa só uma vez, para não encher o Output
                show_debug_message("[OBJETIVO] flag inexistente: " + _o.done);
                _o.warned = true;
            }
            return false;
        }
        return global.flags[$ _o.done];
    }
    if (is_callable(_o.done)) return _o.done();
    return false;
}

/// Texto do objetivo atual ("" se não houver nenhum)
function scr_objective_current() {
    for (var i = 0; i < array_length(global.objectives); i++) {
        var _o = global.objectives[i];
        if (scr_objective_is_done(_o)) continue;                  // já concluído: pula
        if (is_callable(_o.when) && !_o.when()) continue;         // ainda não é hora deste
        return _o.text;
    }
    return "";
}

/// A LISTA DE OBJETIVOS
function scr_build_objectives() {
    global.objectives = [];

    // ---- Puzzle da Estátua ----
	scr_objective_add("...",											  "statue_inspected")
    scr_objective_add("Explorar o Hotel.",								  "slide_puzzle_solved");
    scr_objective_add("Intuitivo, não?",								  "pot_chosen");
    scr_objective_add("Leve para ele.",									  "statue_solved");

    // ---- Puzzle dos Quadros ----
    scr_objective_add("Encontrar uma forma de abrir a porta",		"golden_key_taken", "corridor_door_inspected");
    scr_objective_add("Pelo amor de Deus né...",					"corridor_door_unlocked");
    scr_objective_add("Encontrar o Frasco Vermelho.",               "flask_taken");
    scr_objective_add("Resolva o puzzle para destrancar a porta",	"chalice_filled");
    scr_objective_add("Resolva o puzzle para destrancar a porta",	"chalice_spilled");
    scr_objective_add("Resolva o puzzle para destrancar a porta",	"fish_taken");
    scr_objective_add("Lanterna?",									"hunger_paper_read");
    scr_objective_add("SEJA RÁPIDO",								"paintings_solved");

    // ---- Salas Puzzle (Guimarães): acrescentar aqui, na ordem do jogo ----
    // scr_objective_add("Texto do objetivo.", "flag_que_marca_o_fim", "flag que faz aparecer quando concluída");

    // ---- Cofre e sala final: acrescentem aqui ----
    // scr_objective_add("Abrir o cofre.", "safe_solved");
}