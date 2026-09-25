if (global.interaction_locked) exit;

if (global.selected_item != "") {
    
    if (global.selected_item == "Pote com Dente") {
        
        scr_remove_item_from_inventory("Pote com Dente"); 
        
        global.selected_item = "";
        global.selected_inventory_slot = noone; 
        
        global.flags.statue_solved = true;
        
        dialog_lines = ["Você se mostrou digno de adentrar o hotel.", "Uma pena que não será tão bom quanto você imagina..."];
        scr_show_dialog(dialog_lines, "???", c_red);
        
        instance_create_layer(x, y + 80, "Instances", obj_iron_key);
        
        exit;
    }
    
    else if (global.selected_item == "Pote com Raio" || global.selected_item == "Pote de Zelda") {
        
        global.selected_item = "";
        global.selected_inventory_slot = noone;
        
        instance_create_depth(0, 0, -9999, obj_cutscene_master);
        exit;
    }
    
    else {
        global.selected_item = "";
        global.selected_inventory_slot = noone;
        exit;
    }
}

event_inherited();

