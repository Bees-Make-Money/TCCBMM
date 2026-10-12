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

    return { back: back, forward: forward };
}