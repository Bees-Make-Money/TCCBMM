if (!tv_is_active()) exit;
if (!tv_was_active) exit;  
if (!point_in_rectangle(mouse_x, mouse_y, panel_left, panel_top, panel_left + tv_w, panel_top + tv_h)) exit;
if (global.interaction_locked || was_locked) exit;

var _on  = scr_flag("tv_on");
var _con = scr_flag("console_connected");
var _ctl = scr_flag("controller_connected");

// item selecionado (se outro evento limpar a seleção no mesmo clique, usa a lembrada)
var _selected = global.selected_item;
if (_selected == "") _selected = last_selected;
if (_selected != "") {
    var _item     = _selected;
    var _lines    = ["Humm, parece que isso não está certo."];
    var _consumed = false;

    if (_item == "Console") {
        if (!_on) {
            _lines = ["A TV está desligada. Preciso ligá-la antes de conectar qualquer coisa."];
        }
        else if (_con) {
            _lines = ["O console já está conectado."];
        }
        else {
            scr_remove_item_from_inventory("Console");
            scr_flag_set("console_connected");
            _consumed = true;
            _lines = ["Conectei o console à TV. A tela mudou de cor."];
        }
    }
    else if (_item == "Controle") {
        if (!_on) {
            _lines = ["A TV está desligada. Preciso ligá-la primeiro."];
        }
        else if (!_con) {
            _lines = ["Preciso conectar o console antes de ligar o controle."];
        }
        else if (_ctl) {
            _lines = ["O controle já está conectado."];
        }
        else {
            scr_remove_item_from_inventory("Controle");
            scr_flag_set("controller_connected");
            _consumed = true;
            msg_index  = 0;
            msg_hold   = 0;
            menu_ready = false;
            _lines = ["Conectei o controle. Algo está sendo escrito na tela..."];
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
if (!_on) {
    scr_flag_set("tv_on");
    scr_show_dialog(["A TV ligou. Só barras coloridas na tela... falta uma fonte de sinal."], "Detetive", c_white);
}
else if (!_con) {
    scr_show_dialog(["Só barras coloridas. Preciso conectar um console."], "Detetive", c_white);
}
else if (!_ctl) {
    scr_show_dialog(["O console está conectado, mas sem um controle não dá para jogar."], "Detetive", c_white);
}
else if (tv_phase == "menu") {
    for (var i = 0; i < 3; i++) {
        var _r = card_rect(i);
        if (point_in_rectangle(mouse_x, mouse_y, _r[0], _r[1], _r[2], _r[3])) {
            if (i == 0) {
                // futebol: a escolha certa
                var _f = instance_create_depth(0, 0, -9998, obj_fade);
                _f.target_room = rm_penaltis;
            }
            else {
                // basquete ou carro: a escolha errada
                instance_create_depth(0, 0, -9999, obj_death);
            }
            break;
        }
    }
}
