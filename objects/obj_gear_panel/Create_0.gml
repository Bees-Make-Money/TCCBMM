    event_inherited();

    required_item         = "Engrenagem";
    dialog_lines           = ["Um velho painel mecânico. Faltam engrenagens para o mecanismo funcionar."];
    dialog_lines_repeated  = ["Ainda faltam engrenagens para completar o mecanismo."];

    gear_slots_total  = 3;
    gear_slots_filled = 0;
    panel_solved      = false;

    on_item_success = function() {
        if (panel_solved) exit;

        scr_remove_item_from_inventory(required_item);
        gear_slots_filled++;

        if (gear_slots_filled >= gear_slots_total) {
            panel_solved = true;
            dialog_lines_repeated = ["O painel está consertado."];
            variable_struct_set(global.flags, "gear_panel_solved", true);
        }
    }