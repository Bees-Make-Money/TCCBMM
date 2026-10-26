if (global.interaction_locked) exit;
// ---------- painel escondido, fechado ou aberto ----------
if (!panel_revealed) exit;   // ainda invisível: não responde

var _cl = variable_instance_exists(id, "panel_left") ? panel_left : bbox_left;
var _ct = variable_instance_exists(id, "panel_top")  ? panel_top  : bbox_top;

if (!point_in_rectangle(mouse_x, mouse_y, _cl, _ct, _cl + panel_w, _ct + panel_h)) exit;

if (!panel_open) {
    // fechado: um clique abre a tampa
    panel_open = true;
    exit;
}

// aberto: o botão de latão no canto superior direito fecha a tampa
if (point_in_rectangle(mouse_x, mouse_y, _cl + panel_w - 30, _ct + 8, _cl + panel_w - 8, _ct + 30)) {
    panel_open = false;
    exit;
}

// posição do clique relativa ao canto superior esquerdo do painel
var _mx = mouse_x - bbox_left;
var _my = mouse_y - bbox_top;

// ---------------- jogador está com um item selecionado ----------------
if (global.selected_item != "") {
    var _item     = global.selected_item;
    var _lines    = ["Humm, parece que isso não está certo."];
    var _consumed = false; // só tira a seleção quando o item foi realmente usado

    // ===== ALICATE nos fios =====
    if (_item == "Alicate") {
        if (scr_flag("wiring_fixed")) {
            _lines = ["Já cortei o fio em curto. Não preciso mexer mais nisso."];
        }
        else {
            var _wbest   = -1;
            var _wbest_d = 999999;
            for (var i = 0; i < array_length(wires); i++) {
                var _d = wire_distance(i, _mx, _my);
                if (_d < _wbest_d) {
                    _wbest_d = _d;
                    _wbest   = i;
                }
            }

            if (_wbest_d > wire_click_margin) {
                _lines = ["Preciso usar o alicate diretamente em um dos fios."];
            }
            else if (wires[_wbest].shorted) {
                scr_flag_set("wiring_fixed");
                apply_wiring_state();
                _consumed = true;
				 scr_remove_item_from_inventory("Alicate");
                _lines = ["*clique* Cortei o fio em curto. As faíscas pararam."];

                var _extra = check_solved();
                for (var j = 0; j < array_length(_extra); j++) array_push(_lines, _extra[j]);
            }
            else {
                _lines = ["Esse fio está funcionando bem. Cortá-lo só pioraria as coisas."];
            }
        }
    }
    // ===== ENGRENAGENS nos encaixes =====
    else if (string_pos("Engrenagem", _item) == 1) {
        var _found = -1;
        var _gbest = 9999;
        for (var i = 0; i < array_length(gear_slots); i++) {
            var _s    = gear_slots[i];
            var _edge = point_distance(_mx, _my, _s.lx, _s.ly) - _s.r;
            if (_edge <= gear_click_margin && _edge < _gbest) {
                _gbest = _edge;
                _found = i;
            }
        }

        if (_found == -1) {
            _lines = ["Preciso encaixar a engrenagem em um dos encaixes do mecanismo."];
        }
        else if (scr_flag(gear_slots[_found].flag)) {
            _lines = ["Já há uma engrenagem neste encaixe."];
        }
        else if (gear_slots[_found].item != _item) {
            _lines = ["Essa engrenagem não tem o tamanho certo para este encaixe."];
        }
        else {
            scr_remove_item_from_inventory(_item);
            scr_flag_set(gear_slots[_found].flag);
            _consumed = true;
            _lines = ["Encaixei a " + string_lower(_item) + " no mecanismo."];

            var _extra = check_solved();
            for (var j = 0; j < array_length(_extra); j++) array_push(_lines, _extra[j]);
        }
    }

    if (_consumed) {
        global.selected_item = "";
        global.selected_inventory_slot = noone;
    }

    scr_show_dialog(_lines, "Detetive", c_white);
    exit;
}

// ---------------- clique normal (sem item) ----------------
if (scr_flag("negocios_3_unlocked")) {
    dialog_lines = ["O painel está funcionando e a porta para a próxima sala foi destravada."];
}
else if (scr_flag("gear_panel_solved")) {
    dialog_lines = ["As engrenagens estão no lugar, mas ainda há um fio em curto soltando faíscas."];
}
else if (scr_flag("wiring_fixed")) {
    dialog_lines = ["O fio em curto foi cortado, mas ainda faltam engrenagens no mecanismo."];
}
else {
    dialog_lines = ["Um painel de controle da porta da sala.",
                    "O mecanismo está sem engrenagens e há um fio em curto soltando faíscas.",
                    "Talvez eu encontre o que preciso por aqui."];
}

event_inherited(); // diálogo padrão do obj_hotspot_base
