function scr_get_available_rooms() {
    var key = string(room);
    var neighbors = [];

    if (variable_struct_exists(global.room_map, key)) {
        neighbors = variable_struct_get(global.room_map, key);
    }

    // "De onde vim" só aparece se a sala anterior for vizinha da sala atual
    var back = noone;
    if (global.previous_room != noone
        && global.previous_room != room
        && array_contains(neighbors, global.previous_room)) {
        back = {
            target: global.previous_room,
            label: scr_get_room_label(global.previous_room)
        };
    }

    // Demais vizinhas (menos a que já aparece como "De onde vim")
    var forward = [];
    for (var i = 0; i < array_length(neighbors); i++) {
        var target = neighbors[i];
        if (back != noone && target == back.target) continue;
        array_push(forward, { target: target, label: scr_get_room_label(target) });
    }

    // Botões de ação desta sala (não trocam de sala: executam uma função)
    for (var j = 0; j < array_length(global.menu_actions); j++) {
        var _a = global.menu_actions[j];
        if (_a.room == room && _a.show_if()) {
            array_push(forward, { target: noone, label: _a.label, action: _a.action });
        }
    }

    return { back: back, forward: forward };
}