dialog_lines = [];
dialog_lines_repeated = -1;

on_interact = function(){
	if(!scr_flag("slide_puzzle_solved")){
		instance_create_depth(0, 0, -9999, obj_slide_puzzle)
	}
};