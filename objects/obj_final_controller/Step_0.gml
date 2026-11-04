//necessário para n ter que sair da sala
var _state = 0;
if (scr_flag("ending_sleep")) _state = 2;
else if (scr_flag("hotel_burned")) _state = 1;

if (_state != bg_state) {
    bg_state = _state;
    apply_background();
}