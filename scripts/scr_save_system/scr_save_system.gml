// nome do arquivo de save
#macro SAVE_FILE "savegame.json"

/// Devolve o nome do sprite SE ele for um asset do projeto; senão "" (sprite criado por código).
function scr_sprite_save_name(_spr) {
    if (!sprite_exists(_spr)) return "";
    var _n = sprite_get_name(_spr);
    if (asset_get_type(_n) == asset_sprite && asset_get_index(_n) == _spr) return _n;
    return "";
}

/// Acha o sprite de um item ao carregar. Usa o asset salvo; se o item tinha sprite
/// criado por código, ele é recriado pelo nome do item.
function scr_sprite_for_item(_item_name, _sprite_name) {
    if (_sprite_name != "" && asset_get_type(_sprite_name) == asset_sprite) {
        return asset_get_index(_sprite_name);
    }

    switch (_item_name) {
        case "Balde":              return scr_get_bucket_sprite(false);
        case "Balde com Água":     return scr_get_bucket_sprite(true);
        case "Papel Chamuscado":
            return scr_make_order_paper_sprite(variable_global_exists("fire_order_labels") ? global.fire_order_labels : ["?", "?", "?", "?"]);
        case "Papel Misterioso":
            return scr_make_paper_sprite(variable_global_exists("mystery_digit") ? global.mystery_digit : "?");
        case "Engrenagem Grande":  return scr_get_placeholder_sprite("gear_large");
        case "Engrenagem Média":   return scr_get_placeholder_sprite("gear_medium");
        case "Engrenagem Pequena": return scr_get_placeholder_sprite("gear_small");
        case "Alicate":            return scr_get_placeholder_sprite("pliers");
        case "Console":            return scr_get_simple_placeholder("console", 64, 40, make_color_rgb(70, 70, 78), "CONSOLE");
        case "Controle":           return scr_get_simple_placeholder("controller", 56, 36, make_color_rgb(60, 60, 110), "CONTROLE");
    }

    // qualquer outro item sem sprite de asset: quadrado provisório com o nome
    return scr_get_simple_placeholder("item_" + _item_name, 48, 48, make_color_rgb(80, 60, 40), _item_name);
}

/// Grava o progresso. Devolve true se salvou.
function scr_save_game() {
    var _data = {
        version: 1,
        room: room_get_name(room),
        previous_room: (global.previous_room == noone) ? "" : room_get_name(global.previous_room),
        flags: global.flags,
        room_visits: global.room_visits,
        inventory: [],
        fire_order_labels: variable_global_exists("fire_order_labels") ? global.fire_order_labels : [],
        mystery_digit: variable_global_exists("mystery_digit") ? global.mystery_digit : -1
    };

    // inventário (slot vazio vira 0)
    for (var i = 0; i < array_length(global.inventory_items); i++) {
        var _it = global.inventory_items[i];
        if (_it == noone) {
            array_push(_data.inventory, 0);
        }
        else {
            array_push(_data.inventory, { name: _it.name, sprite: scr_sprite_save_name(_it.sprite) });
        }
    }

    var _json = json_stringify(_data);
    var _buf  = buffer_create(string_byte_length(_json) + 1, buffer_fixed, 1);
    buffer_write(_buf, buffer_string, _json);
    buffer_save(_buf, SAVE_FILE);
    buffer_delete(_buf);

    return file_exists(SAVE_FILE);
}

/// Carrega o progresso e leva o jogador à sala onde salvou. Devolve true se carregou.
function scr_load_game() {
    if (!file_exists(SAVE_FILE)) return false;

    var _buf  = buffer_load(SAVE_FILE);
    var _json = buffer_read(_buf, buffer_string);
    buffer_delete(_buf);

    var _data = json_parse(_json);

    // flags: só sobrescreve as que existem no save (flags novas ficam no padrão)
    var _names = variable_struct_get_names(_data.flags);
    for (var i = 0; i < array_length(_names); i++) {
        global.flags[$ _names[i]] = _data.flags[$ _names[i]];
    }

    global.room_visits = _data.room_visits;

    // valores usados para refazer os papéis do inventário
    if (variable_struct_exists(_data, "fire_order_labels") && array_length(_data.fire_order_labels) > 0) {
        global.fire_order_labels = _data.fire_order_labels;
    }
    if (variable_struct_exists(_data, "mystery_digit") && _data.mystery_digit != -1) {
        global.mystery_digit = _data.mystery_digit;
    }

    // inventário
    var _inv = array_create(10, noone);
    for (var j = 0; j < min(10, array_length(_data.inventory)); j++) {
        var _s = _data.inventory[j];
        if (is_struct(_s)) {
            _inv[j] = { sprite: scr_sprite_for_item(_s.name, _s.sprite), name: _s.name };
        }
    }
    global.inventory_items = _inv;

    global.selected_item = "";
    global.selected_inventory_slot = noone;
    global.lock_count = 0;
    global.interaction_locked = false;

    var _pr = _data.previous_room;
    global.previous_room = (_pr != "" && asset_get_type(_pr) == asset_room) ? asset_get_index(_pr) : noone;

    // sala onde salvou (se não existir mais, volta para o hall)
    var _target = rm_hall_entrada;
    if (asset_get_type(_data.room) == asset_room) _target = asset_get_index(_data.room);

    var _f = instance_create_depth(0, 0, -9998, obj_fade);
    _f.target_room = _target;
    return true;
}

/// Reinicia o jogo do começo. _delete_save = true também apaga o save.
function scr_reset_progress(_delete_save) {
    if (_delete_save && file_exists(SAVE_FILE)) file_delete(SAVE_FILE);
    audio_resume_all();
    game_restart();
}
