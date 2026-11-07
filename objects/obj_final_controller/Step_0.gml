//necessário para n ter que sair da sala
var _state = 0;
if (scr_flag("ending_sleep")) _state = 2;
else if (scr_flag("hotel_burned")) _state = 1;

if (_state != bg_state) {
    bg_state = _state;
    apply_background();
}
if (!global.interaction_locked) {
    for (var i = 0; i < 5; i++) {
        if (keyboard_check_pressed(ord("1") + i) || keyboard_check_pressed(vk_numpad1 + i)) {
            scr_open_book_from_slot(i);
        }
    }
}