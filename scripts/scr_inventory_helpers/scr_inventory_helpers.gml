/// Remove um item do inventário e, se ele estava selecionado, limpa a seleção.
/// Devolve true se removeu.
function scr_consume_item(_name) {
    var _removed = scr_remove_item_from_inventory(_name);
    if (_removed && global.selected_item == _name) {
        global.selected_item = "";
        global.selected_inventory_slot = noone;
    }
    return _removed;
}

/// Tenta adicionar um item ao inventário. Se estiver cheio, avisa o jogador.
/// Devolve true se adicionou.
function scr_try_give_item(_sprite, _name) {
    var _added = scr_add_item_to_inventory(_sprite, _name);
    if (!_added) {
        scr_show_dialog(["Não tenho mais espaço no inventário."], "Detetive", c_white);
    }
    return _added;
}

function scr_inventory_has_space() {
    for (var i = 0; i < array_length(global.inventory_items); i++) {
        if (global.inventory_items[i] == noone) return true;
    }
    return false;
}
/// Esvazia o inventário inteiro e limpa a seleção e as reservas.
function scr_inventory_clear() {
    for (var i = 0; i < array_length(global.inventory_items); i++) {
        global.inventory_items[i] = noone;
    }
    global.inventory_reserved = array_create(array_length(global.inventory_items), false);
    global.selected_item = "";
    global.selected_inventory_slot = noone;
    scr_close_item_menu();
}

/// Slot (0 = primeiro) em que está o item de nome _name, ou -1.
function scr_inventory_find(_name) {
    for (var i = 0; i < array_length(global.inventory_items); i++) {
        var _it = global.inventory_items[i];
        if (_it != noone && _it.name == _name) return i;
    }
    return -1;
}

/// Devolve o item do slot (0 = primeiro) ou noone.
function scr_inventory_get(_slot) {
    if (_slot < 0 || _slot >= array_length(global.inventory_items)) return noone;
    return global.inventory_items[_slot];
}

/// Coloca um item em um slot específico, se estiver livre. Devolve true se colocou.
function scr_inventory_set(_slot, _sprite, _name) {
    if (_slot < 0 || _slot >= array_length(global.inventory_items)) return false;
    if (global.inventory_items[_slot] != noone) return false;
    global.inventory_items[_slot] = { sprite: _sprite, name: _name };
    return true;
}