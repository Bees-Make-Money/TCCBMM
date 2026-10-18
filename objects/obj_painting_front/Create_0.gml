event_inherited();

s_cover  = spr_painting_front_covered;
s_entity = spr_painting_front_entity;
s_empty  = spr_painting_front_empty;

apply_state = function() {
    image_speed = 0;
    image_index = 0;

    if (scr_flag("paintings_solved")) {
        sprite_index = s_empty;
        required_item = "";
        dialog_lines = [];
    }
    else if (scr_flag("hunger_paper_read")) {
        sprite_index = s_entity;
        required_item = ITEM_PEIXE;
        dialog_lines = ["Um ser completamente negro, de olhos brancos, me encara de dentro do quadro."];   // provisório
    }
    else {
        sprite_index = s_cover;
        required_item = "";
        dialog_lines = ["Este quadro está coberto por um pano escuro."];
    }
};

on_item_success = function() {
    scr_consume_item(ITEM_PEIXE);
    scr_flag_set("paintings_solved");

    var _fx = instance_create_depth(0, 0, -1500, obj_glitch_effect);
    _fx.duration = 60;
    _fx.on_peak = function() {
        with (obj_painting_base) apply_state();
        with (obj_dark_claws) instance_destroy();	
    };
};

apply_state();