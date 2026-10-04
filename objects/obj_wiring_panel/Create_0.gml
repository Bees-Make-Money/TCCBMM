event_inherited();

    required_item        = "Alicate";
    dialog_lines          = ["Um quadro de fiação antigo. Alguns fios parecem estar em curto."];
    dialog_lines_repeated = ["Ainda há fios em curto para consertar."];

    wire_count   = 4;
    wires_fixed  = array_create(wire_count, false);
    panel_solved = false;

    on_item_success = function() {
        if (panel_solved) exit;

        // conserta o primeiro fio em curto que encontrar
        for (var i = 0; i < wire_count; i++) {
            if (!wires_fixed[i]) {
                wires_fixed[i] = true;
                break;
            }
        }

        var _all_fixed = true;
        for (var i = 0; i < wire_count; i++) {
            if (!wires_fixed[i]) _all_fixed = false;
        }

        if (_all_fixed) {
            panel_solved = true;
            dialog_lines_repeated = ["A fiação está normalizada."];
            variable_struct_set(global.flags, "wiring_fixed", true);
        }
    }
