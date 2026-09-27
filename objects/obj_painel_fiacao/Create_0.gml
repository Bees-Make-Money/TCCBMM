event_inherited();

custom_click = function() {
    if (!global.flags.fiacao_consertada) {
        if (global.selected_item == "Alicate") {
            global.flags.fiacao_consertada = true;
            global.selected_item = ""; 
            global.selected_inventory_slot = noone;
            
            show_message("Você isolou e consertou a fiação principal!");
        } else {
            show_message("Os fios estão desencapados. Selecione o Alicate no inventário.");
        }
    } else {
        show_message("A fiação já foi consertada.");
    }
}