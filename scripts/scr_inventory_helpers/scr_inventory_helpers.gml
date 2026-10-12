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