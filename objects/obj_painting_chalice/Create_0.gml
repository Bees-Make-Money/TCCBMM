event_inherited();

s_main    = spr_painting_chalice;          
s_spilled = spr_painting_spilled_chalice;    

apply_state = function() {
    image_speed = 0;

    if (scr_flag("chalice_spilled")) {
        sprite_index = s_spilled;
        image_index = 0;
        required_item = "";
        dialog_lines = ["Eita bixo, fiz uma lambança aqui."];  
    }
    else if (scr_flag("chalice_filled")) {
        sprite_index = s_main;
        image_index = image_number - 1;        
        required_item = "";
        dialog_lines = [];                      
    }
    else {
        sprite_index = s_main;
        image_index = 0;                         // primeiro frame = azul
        required_item = ITEM_FRASCO;
        dialog_lines = ["Um cálice com água?"];
    }
};

on_item_success = function() {
    scr_consume_item(ITEM_FRASCO);
    scr_flag_set("chalice_filled");
    play_anim(s_main, function() {
        apply_state();                              
        with (obj_painting_hammer) apply_state();   // agora o martelo pode ser pego
    });
};

on_interact = function() {
    if (scr_flag("chalice_filled") && !scr_flag("chalice_spilled")) {
        scr_flag_set("chalice_spilled");
        apply_state();
        with (obj_painting_aquarium) turn_red();
    }
};

apply_state();