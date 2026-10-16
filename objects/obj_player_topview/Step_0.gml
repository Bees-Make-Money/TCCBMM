if (global.interaction_locked || dead || entering_portal) exit;

// Entrada: -1, 0 ou 1 em cada eixo (setas ou WASD)
var _dx = (keyboard_check(vk_right) || keyboard_check(ord("D"))) - (keyboard_check(vk_left) || keyboard_check(ord("A")));
var _dy = (keyboard_check(vk_down)  || keyboard_check(ord("S"))) - (keyboard_check(vk_up)   || keyboard_check(ord("W")));

// Na diagonal, reduz o passo de cada eixo para manter a velocidade total parecida (3 -> 2)
var _steps = (_dx != 0 && _dy != 0) ? round(move_speed * 0.7071) : move_speed;

// Cada eixo se move sozinho
if (_dx != 0) move_axis(_dx, 0, _steps, _dy == 0);
if (_dy != 0) move_axis(0, _dy, _steps, _dx == 0);

// Mantém a hitbox dentro da sala
var _off_l = x - bbox_left;
var _off_r = bbox_right - x;
var _off_t = y - bbox_top;
var _off_b = bbox_bottom - y;
x = clamp(x, _off_l, room_width  - _off_r);
y = clamp(y, _off_t, room_height - _off_b);

// Portal: leva ao labirinto 2
if (place_meeting(x, y, obj_portal)) {
    entering_portal = true;
    scr_change_room(rm_labirinto_2);
}