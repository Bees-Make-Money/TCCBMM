if (global.interaction_locked) exit;

// Vão ocupado: o livro certo é fixo, e o errado pode ser retirado
if (global.final_shelf[slot_index] != 0) {
    if (!is_correct()) take_back();
    exit;
}

// Vão vazio: precisa de um livro selecionado no inventário
if (global.selected_item != "") {
    var _book = scr_book_id_from_item(global.selected_item);
    if (_book != 0) {
        place_book(_book);
    } else {
        scr_show_dialog(["Humm, parece que isso não está certo."], "Detetive", c_white);
        global.selected_item = "";
        global.selected_inventory_slot = noone;
    }
    exit;
}

scr_show_dialog(["Tem um espaço vazio na estante. Claramente faltam livros aqui."], "Detetive", c_white); 