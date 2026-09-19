if (global.interaction_locked) exit;

if(click_count == 0 || dialog_lines_repeated == -1){
	scr_show_dialog(dialog_lines);
}
else{
	scr_show_dialog(dialog_lines_repeated);
}
click_count++;