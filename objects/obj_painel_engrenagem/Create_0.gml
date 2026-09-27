event_inherited();

custom_click = function() {
    if (global.engrenagens_colocadas < global.total_engrenagens) {
        if (global.selected_item == "Engrenagem") {
            global.engrenagens_colocadas += 1;
            if (global.selected_inventory_slot != noone) {
                global.inventory_items[global.selected_inventory_slot] = noone;
                global.selected_item = "";
                global.selected_inventory_slot = noone;
            }
            
            var offset_x = (global.engrenagens_colocadas - 1) * 40; 
            var offset_y = (global.engrenagens_colocadas - 1) * 15;
            instance_create_layer(x + 20 + offset_x, y + 20 + offset_y, "Instances", obj_engrenagem_visual);
            
            show_message("Você encaixou a engrenagem. Faltam: " + string(global.total_engrenagens - global.engrenagens_colocadas));
        } else {
            show_message("Abra o inventário, selecione uma engrenagem e clique aqui para encaixar.");
        }
    } else {
        show_message("O painel de engrenagens já está cheio.");
    }
}
