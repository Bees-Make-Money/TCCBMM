/// Step Event
if fade_in {
    switch(phase) {
        case 0: // Fade in (escurecer)
            alpha += fade_speed;
            text_alpha = alpha;
            if alpha >= 1 {
                phase = 1;
                text_alpha = 1;
            }
            break;
            
        case 1: // Digitação da frase atual
            var current_phrase = transition_texts[current_text_index];
            
            if text_index < string_length(current_phrase) {
                text_index += text_speed;
                text_display = string_copy(current_phrase, 1, floor(text_index));
            } else {
                // Frase digitada completamente
                phase = 2;
                phase_timer = time_between_texts;
            }
            break;
            
        case 2: // Aguardar antes de próxima frase
            phase_timer--;
            if phase_timer <= 0 {
                current_text_index++;
                
                if current_text_index < array_length(transition_texts) {
                    // Há mais frases, volta para digitação
                    phase = 1;
                    text_index = 0;
                    text_display = "";
                } else {
                    // Acabaram as frases, fade out
                    phase = 3;
                }
            }
            break;
            
        case 3: // Fade out (sair)
            alpha -= fade_speed;
            text_alpha = alpha;
            if alpha <= 0 {
                room_goto(next_room);
                alpha = 0;
                fade_in = false;
            }
            break;
    }
}
