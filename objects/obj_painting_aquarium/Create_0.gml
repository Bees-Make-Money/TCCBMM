event_inherited();

s_main   = spr_painting_aquarium;           
s_broken = spr_painting_aquarium_broken;    
s_empty  = spr_painting_aquarium_empty;     

apply_state = function() {
    image_speed = 0;

    if (scr_flag("fish_taken")) {
        sprite_index = s_empty;
        image_index = 0;
        required_item = "";
        dialog_lines = ["Nem pra eu conseguir pegar um caco pra me defender né? Hotel disgranhento."];                 // provisório
    }
    else if (scr_flag("aquarium_broken")) {
        sprite_index = s_broken;
        image_index = 0;
        required_item = "";
        dialog_lines = [];                                        // sem fala: o clique pega o peixe (on_interact)
    }
    else if (scr_flag("aquarium_red")) {
        sprite_index = s_main;
        image_index = image_number - 1;                           // último frame = água vermelha
        required_item = ITEM_MARTELO;
        dialog_lines = ["Será que eu consigo libertá-lo de alguma forma?"];
    }
    else {
        sprite_index = s_main;
        image_index = 0;                                          // primeiro frame = água azul
        required_item = ITEM_MARTELO;
        dialog_lines = ["Que aquário bonito. Tomara que o vidro seja forte, caso contrário, alguém poderia quebrá-lo..."];
    }
};

turn_red = function() {
    scr_flag_set("aquarium_red");
    play_anim(s_main, function() {
        apply_state();
        scr_show_dialog(["O que aconteceu?!", "A água do aquário ficou toda vermelha...", "O peixe ficou preso na água vermelha, coitado."], "Detetive", c_white);
    });
};

on_item_success = function() {
    if (scr_flag("aquarium_red")) {
        scr_consume_item(ITEM_MARTELO);
        scr_flag_set("aquarium_broken");
        apply_state();
        scr_show_dialog(["Cara, como que isso é possível? Eu estou interagindo com pinturas?", "Bom, agora o peixe está morrendo né, não adiantou ser liberto."], "Detetive", c_white);   // provisório
    } else {
        scr_show_dialog(["Eu ainda não posso usar isso aqui."], "Detetive", c_white);
    }
};

on_interact = function() {
    if (scr_flag("aquarium_broken") && !scr_flag("fish_taken")) {
        if (scr_try_give_item(spr_fish, ITEM_PEIXE)) {  
            scr_flag_set("fish_taken");
            apply_state();
        }
    }
};

apply_state();