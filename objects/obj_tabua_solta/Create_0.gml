event_inherited();

custom_click = function() {
    if (!global.flags.chave_encontrada) {
        var _adicionado = false;
        for (var i = 0; i < array_length(global.inventory_items); i++) {
            if (global.inventory_items[i] == noone) {
                global.inventory_items[i] = { name: "Chave Antiga", sprite: spr_chave };
                _adicionado = true;
                break;
            }
        }
        
        if (_adicionado) {
            global.flags.chave_encontrada = true;
            show_message("Você afastou a tábua e encontrou uma Chave Antiga!");
        } else {
            show_message("Inventário cheio! Libere espaço para pegar o que está aqui.");
        }
    } else {
        show_message("Você já pegou tudo o que havia debaixo desta tábua.");
    }
}