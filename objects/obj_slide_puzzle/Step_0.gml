if (puzzle_state == "playing") {
    var _mov = 0;

    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
        if (empty_pos <= 5) _mov = 3; 
    }
    else if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        if (empty_pos >= 3) _mov = -3; 
    }
    else if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"))) {
        if (empty_pos mod 3 != 2) _mov = 1; 
    }
    else if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"))) {
        if (empty_pos mod 3 != 0) _mov = -1; 
    }

    if (_mov != 0) {
        grid[empty_pos] = grid[empty_pos + _mov];
        grid[empty_pos + _mov] = 0;
        empty_pos += _mov;
        var _correto = true;
        for (var i = 0; i < 8; i++) {
            if (grid[i] != i + 1) {
                _correto = false;
                break; 
            }
        }
        
        if (_correto && grid[8] == 0) {
            won = true;
            puzzle_state = "fading_out";
        }
    }
}
else if (puzzle_state == "fading_out") {
    alpha_pieces -= 0.02; 
    if (alpha_pieces <= 0) {
        alpha_pieces = 0;
        puzzle_state = "text_in";
    }
}
else if (puzzle_state == "text_in") {
    alpha_text += 0.02; 
    if (alpha_text >= 1) {
        alpha_text = 1;
    }
    
    if (mouse_check_button_pressed(mb_left)) {
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        
        var _gui_w = display_get_gui_width();
        var _gui_h = display_get_gui_height();
        
        var _bw = 80;
        var _bh = 50;
        var _bx = (_gui_w / 2) - (_bw / 2);
        var _by = (_gui_h / 2) + 120;
        
        if (point_in_rectangle(_mx, _my, _bx, _by, _bx + _bw, _by + _bh)) {
            instance_destroy();
        }
    }
}