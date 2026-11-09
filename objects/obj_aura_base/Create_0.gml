image_speed = 0;
anim_playing = false;
image_index = scr_flag("final_sequence_done") ? image_number - 1 : 0;

// Toca a animação uma vez (do livro normal até a aura acesa) e fica no último frame
play_aura = function() {
    if (anim_playing) return;
    image_index = 0;
    image_speed = 1;
    anim_playing = true;
};