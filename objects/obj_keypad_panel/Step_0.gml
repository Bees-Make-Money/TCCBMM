// Primeiro step: ignora o clique que abriu o painel
if (!can_click) {
    can_click = true;
    exit;
}

// Esc fecha o painel
if (keyboard_check_pressed(vk_escape)) {
    instance_destroy();
    exit;
}

if (bad_timer > 0) bad_timer--;

// Enter confirma
if (keyboard_check_pressed(vk_enter)) {
    submit();
    exit;
}

// Backspace apaga a última letra
if (keyboard_check_pressed(vk_backspace) && string_length(typed) > 0) {
    typed = string_copy(typed, 1, string_length(typed) - 1);
}

// Clique em uma letra
if (mouse_check_button_pressed(mb_left) && string_length(typed) < max_len) {
    for (var i = 0; i < 26; i++) {
        var _r = button_rect(i);
        if (point_in_rectangle(mouse_x, mouse_y, _r[0], _r[1], _r[2], _r[3])) {
            typed += chr(ord("A") + i);
            break;
        }
    }
}