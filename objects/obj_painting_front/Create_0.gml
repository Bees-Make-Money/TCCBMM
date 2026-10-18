event_inherited();

s_cover  = spr_painting_front_covered;    
s_entity = spr_painting_front_entity;

apply_state = function() {
    image_speed = 0;
    image_index = 0;

    if (scr_flag("hunger_paper_read")) {
        sprite_index = s_entity;
        dialog_lines = ["O que é isso? Eu preciso alimentá-lo?!"];
    }
    else {
        sprite_index = s_cover;
        dialog_lines = ["Que estranho, esse quadro está comberto com um pano."];
    }
};

apply_state();