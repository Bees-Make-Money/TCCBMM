event_inherited();

s_field = spr_painting_field;         
s_fire  = spr_painting_field_onfire;   

apply_state = function() {
    image_speed = 0;
    image_index = 0;
	sprite_index = spr_painting_field;
	
	if(scr_flag("paintings_solved")){
		dialog_lines = ["Eu devo seguir em frente..."]
	}
    else if (scr_flag("hunger_paper_read")) {
        sprite_index = s_fire;
        dialog_lines = ["Que horror, o campo inteiro está em CHAMAS!"]
	}
    else {
        dialog_lines = ["Um campo florido. Me lembra minha terra natal."];
    }
};

apply_state();
