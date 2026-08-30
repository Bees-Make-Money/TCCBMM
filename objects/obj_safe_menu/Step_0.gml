if(!can_close){
	can_close = true
}

for (var i = 0; i < 4; i++) {
    if (anim_offset[i] != 0) {
        anim_offset[i] = lerp(anim_offset[i], 0, anim_speed);
        if (abs(anim_offset[i]) < 0.05) {
            anim_offset[i] = 0;
            digits[i] = target_digits[i];
        }
    }
}

if (mouse_check_button_pressed(mb_left)) {
    var mx = mouse_x;
    var my = mouse_y;
    var arrow_size = 24;
    
    for (var i = 0; i < 4; i++) {
        var pos_x = start_x + i * (square_width + spacing);
        var y_arrow_up = start_y - 55;
        var y_arrow_down = start_y + 55;
        
        if (point_in_rectangle(mx, my, pos_x - arrow_size, y_arrow_up - arrow_size, pos_x + arrow_size, y_arrow_up + arrow_size)) {
            target_digits[i] = (digits[i] + 1) % 10;
            anim_offset[i] = 18; 
        }
        
        if (point_in_rectangle(mx, my, pos_x - arrow_size, y_arrow_down - arrow_size, pos_x + arrow_size, y_arrow_down + arrow_size)) {
            target_digits[i] = (digits[i] - 1 + 10) % 10;
            anim_offset[i] = -18; 
        }
    }
}

var is_correct = true;
for (var i = 0; i < 4; i++) {
    if (target_digits[i] != correct_password[i]) {
        is_correct = false;
        break;
    }
}

if (is_correct && anim_offset[0] == 0 && anim_offset[1] == 0 && anim_offset[2] == 0 && anim_offset[3] == 0) {
    global.safe_solved = true;
	if (instance_exists(safe_origin)) {
        safe_origin.solved = true;
		with(safe_origin){
			instance_destroy()
		}
    }
    
    instance_create_layer(x, y + 100, "Instances", obj_iron_key);
    instance_destroy();
}
