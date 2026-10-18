event_inherited();
image_speed = 0;
apply_state = function() { };

// Animação que toca UMA vez: _sprite é a strip; _done (opcional) roda quando ela termina
anim_playing = false;
anim_done = -1;
play_anim = function(_sprite, _done = -1) {
    if (anim_playing) return;
    sprite_index = _sprite;
    image_index = 0;
    image_speed = 1;
    anim_playing = true;
    anim_done = _done;
    scr_lock();                 // o jogador não pode clicar durante a animação
};