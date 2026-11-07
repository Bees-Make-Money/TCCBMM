slot_number = 0;    // posição na estante (o filho define: 2, 7, 11, 18 ou 25)
slot_index = 0;     // posição na lista dos 5 vãos (o filho define: 0 a 4)

// O livro que está neste vão é o certo?
is_correct = function() {
    return global.final_shelf[slot_index] == slot_number;
};

// Coloca o livro _book (2, 7, 11, 18 ou 25), que está no inventário, neste vão
place_book = function(_book) {
    var _name = scr_book_item_name(_book);
    var _inv = scr_inventory_find(_name);
    if (_inv == -1) return;

    // Tira do inventário e reserva o slot (se o livro voltar, volta para o mesmo lugar)
    global.inventory_items[_inv] = noone;
    global.inventory_reserved[_inv] = true;
    global.final_book_slot[scr_final_index_of(_book)] = _inv;
    global.final_shelf[slot_index] = _book;

    global.selected_item = "";
    global.selected_inventory_slot = noone;

    if (is_correct()) {
        // Acertou: o livro nunca mais volta ao inventário
        global.inventory_reserved[_inv] = false;
        global.final_book_slot[scr_final_index_of(_book)] = -1;
        scr_toast("Livro Posicionado Corretamente");
        scr_final_check_done();
    }
};

// Devolve o livro (errado) ao inventário, no mesmo slot de antes
take_back = function() {
    var _book = global.final_shelf[slot_index];
    var _bi = scr_final_index_of(_book);
    var _inv = global.final_book_slot[_bi];
    var _icon = scr_book_icon(_book);
    var _name = scr_book_item_name(_book);

    if (_inv >= 0) global.inventory_reserved[_inv] = false;
    global.final_shelf[slot_index] = 0;
    global.final_book_slot[_bi] = -1;

    // Volta para o mesmo slot (se por algum motivo estiver ocupado, vai para o primeiro livre)
    if (_inv < 0 || !scr_inventory_set(_inv, _icon, _name)) {
        scr_add_item_to_inventory(_icon, _name);
    }
};