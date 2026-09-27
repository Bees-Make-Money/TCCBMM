event_inherited();

custom_click = function() {
    var _adicionado = false;
    for (var i = 0; i < array_length(global.inventory_items); i++) {
        if (global.inventory_items[i] == noone) {
            global.inventory_items[i] = {
                name: "Alicate",
                sprite: spr_alicate
            };
            _adicionado = true;
            break;
        }
    }
    
    if (_adicionado) instance_destroy();
}