//posição dos livros
function scr_final_index_of(_id) {
    switch (_id) {
        case 2:  return 0;
        case 7:  return 1;
        case 11: return 2;
        case 18: return 3;
        case 25: return 4;
    }
    return -1;
}

function scr_book_id_from_item(_name) {
    switch (_name) {
        case ITEM_LIVRO_02: return 2;
        case ITEM_LIVRO_07: return 7;
        case ITEM_LIVRO_11: return 11;
        case ITEM_LIVRO_18: return 18;
        case ITEM_LIVRO_25: return 25;
    }
    return 0;
}

/// Nome do item a partir do número do livro.
function scr_book_item_name(_id) {
    switch (_id) {
        case 2:  return ITEM_LIVRO_02;
        case 7:  return ITEM_LIVRO_07;
        case 11: return ITEM_LIVRO_11;
        case 18: return ITEM_LIVRO_18;
        case 25: return ITEM_LIVRO_25;
    }
    return "";
}

function scr_book_icon(_id) {
    switch (_id) {
        case 2:  return object_get_sprite(obj_livro_sala_02);
        case 7:  return object_get_sprite(obj_livro_sala_07);
        case 11: return object_get_sprite(obj_livro_sala_11);
        case 18: return object_get_sprite(obj_livro_sala_18);
        case 25: return object_get_sprite(obj_livro_sala_25);
    }
    return -1;
}

/// Texto de um livro.
function scr_book_text(_name) {
    switch (_name) {
        case ITEM_LIVRO_02:
            return "Harry Potter e a Câmara Secreta";
        case ITEM_LIVRO_07:
            return "Pecados Capitais";
        case ITEM_LIVRO_11:
            return "Homens e um Segredo";
        case ITEM_LIVRO_18:
            return "Android - DBZ";
        case ITEM_LIVRO_25:
            return "(tons de cinza) / 2";
        case ITEM_LIVRO_BIZARRO:
            return "eu (S)ei que um fina(L) lindo me esp(E)ra com o t(E)m(P)o";
    }
    return "";
}

function scr_open_book_from_slot(_slot) {
    var _item = scr_inventory_get(_slot);
    if (_item == noone) return;

    var _text = scr_book_text(_item.name);
    if (_text == "") return;                                  // não é um livro

    var _reader = instance_create_depth(0, 0, -500, obj_livro_aberto);
    _reader.book_text = _text;
}
/// Zera o estado da estante (chamado no início do jogo, no reset do puzzle e no debug).
function scr_final_state_reset() {
    global.final_books = [2, 7, 11, 18, 25];                     // o livro certo de cada vão
    global.final_shelf = [0, 0, 0, 0, 0];                        // que livro está em cada vão (0 = vazio)
    global.final_book_slot = [-1, -1, -1, -1, -1];               // de que slot do inventário cada livro saiu
    global.inventory_reserved = array_create(array_length(global.inventory_items), false);
}

/// Se os 5 vãos têm o livro certo, marca final_books_done.
function scr_final_check_done() {
    for (var i = 0; i < 5; i++) {
        if (global.final_shelf[i] != global.final_books[i]) return;
    }
    scr_flag_set("final_books_done");
}

/// Mostra uma mensagem curta, com fade, no alto da sala.
function scr_toast(_text) {
    var _t = instance_create_depth(0, 0, -9000, obj_toast);
    _t.text = _text;
}
/// A senha FUJA foi aceita: um glitch cobre a tela e, no pico, a sala vira a versão assustadora.
function scr_final_fuja_accepted() {
    var _fx = instance_create_depth(0, 0, -1500, obj_glitch_effect);
    _fx.duration = 60;
    _fx.on_peak = function() {
        scr_flag_set("hotel_burned");      // o controller troca o background para a sala escura
        // Fase 6: aqui começa a contagem de 30 segundos
    };
}