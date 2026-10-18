event_inherited();

s_full  = spr_painting_hammer;
s_empty = spr_painting_hammer_empty;

apply_state = function() {
    image_speed = 0;

    if (scr_flag("hammer_taken")) {
        sprite_index = s_empty;
        image_index = 0;
        dialog_lines = ["Já peguei esse brucutu."];
    }
    else if (scr_flag("chalice_filled")) {
        sprite_index = s_full;
        image_index = 0;
        dialog_lines = [];
    }
    else {
        sprite_index = s_full;
        image_index = 0;
        dialog_lines = ["Olha o tamanho desse martelo... Quem usa um treco desses?"];
    }
};

on_interact = function() {
    if (scr_flag("chalice_filled") && !scr_flag("hammer_taken")) {
        if (scr_try_give_item(spr_hammer, ITEM_MARTELO)) {
            scr_flag_set("hammer_taken");
            apply_state();
        }
    }
};

apply_state();