function scr_get_available_rooms() {
    var back = noone;

    if (global.previous_room != noone && global.previous_room != room) {
        back = {
            target: global.previous_room,
            label: scr_get_room_label(global.previous_room)
        };
    }

    var forward = [];
    var key = string(room);

    if (variable_struct_exists(global.room_map, key)) {
        var neighbors = variable_struct_get(global.room_map, key);

        for (var i = 0; i < array_length(neighbors); i++) {
            var target = neighbors[i];

            if (back != noone && back.target == target) continue;

            array_push(forward, {
                target: target,
                label: scr_get_room_label(target)
            });
        }
    }

    return { back: back, forward: forward };
}