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
// ---- Sequência das auras (depois que os 5 livros estão certos) ----
switch (seq_state) {
    case 0:
        if (scr_flag("final_books_done") && !scr_flag("final_sequence_done")) {
            seq_state = 1;
            seq_timer = 0;
            scr_lock();                       // a interação fica travada durante a sequência
        }
    break;

    case 1:                                    // 2 s com a estante parada
        seq_timer++;
        if (seq_timer >= wait_steps) {
            seq_state = 2;
            seq_index = 0;
            seq_wait_anim = false;
            seq_timer = 0;
        }
    break;

    case 2: {                                  // acende uma aura de cada vez
        var _inst = instance_find(aura_objects[seq_index], 0);

        if (!seq_wait_anim) {
            if (_inst != noone) _inst.play_aura();
            seq_wait_anim = true;
            seq_timer = 0;
        }
        else {
            var _playing = (_inst != noone) && _inst.anim_playing;
            if (!_playing) {                   // a animação terminou: pausa e passa para a próxima
                seq_timer++;
                if (seq_timer >= gap_steps) {
                    seq_index++;
                    seq_wait_anim = false;
                    if (seq_index >= array_length(aura_objects)) {
                        scr_flag_set("final_sequence_done");
                        seq_state = 3;
                        scr_unlock();
                    }
                }
            }
        }
    }
    break;
}