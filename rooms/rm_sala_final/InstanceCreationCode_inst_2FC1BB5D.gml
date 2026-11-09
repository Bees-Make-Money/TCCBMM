dialog_lines = [];
on_interact = function() {
    if (!instance_exists(obj_keypad_panel)) instance_create_depth(0, 0, -500, obj_keypad_panel);
};