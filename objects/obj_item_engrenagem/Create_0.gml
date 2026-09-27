event_inherited(); 

custom_click = function() {
    var _adicionado = false;
    for (var i = 0; i < array_length(global.inventory_items); i++) {
        if (global.inventory_items[i] == noone) {
            global.inventory_items[i] = {
                name: "Engrenagem",
                sprite: spr_engrenagem
            };
            _adicionado = true;
            break; 
        }
    }
    
    if (_adicionado) {
        show_debug_message("Engrenagem adicionada!");
        instance_destroy(); 
    } else {
        show_message("Seu inventário está cheio!");
    }
}