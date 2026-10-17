if (global.interaction_locked || dead || entering_portal) exit;

if (boost_timer > 0) boost_timer--;
image_blend = (boost_timer > 0) ? c_aqua : c_white;

var _dx = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
var _dy = (keyboard_check(vk_down)  || keyboard_check(ord("S"))) - (keyboard_check(vk_up)   || keyboard_check(ord("W")));

if (_dx != 0 || _dy != 0) {
    var _speed = (boost_timer > 0) ? boost_speed : move_speed;
    if (_dx != 0 && _dy != 0) _speed *= 0.7071;   // diagonal garantindo velocidade total similar

    // Velocidade fracionária: anda a parte inteira e guarda o resto para o próximo step
    move_acc += _speed;
    var _steps = floor(move_acc);
    move_acc -= _steps;

    repeat (_steps) {
        //Move 1 pixel no eixo X
        if (_dx != 0) {
            //Pssa 1 como argumento de passos
            move_axis(_dx, 0, 1, _dy == 0);
        }
        //Move 1 pixel no eixo Y
        if (_dy != 0) {
            // Passamos '1' como o argumento de passos para a sua função
            move_axis(0, _dy, 1, _dx == 0);
        }
    };
} 
else {
    move_acc = 0;
}

x = clamp(x, _off_l, room_width  - _off_r);
y = clamp(y, _off_t, room_height - _off_b);

// Portal: leva ao labirinto 2
if (place_meeting(x, y, obj_portal)) {
    entering_portal = true;
    scr_change_room(rm_labirinto_2);
}