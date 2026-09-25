if (global.interaction_locked) exit;

if (global.selected_item != "") {
    
    if (global.selected_item == required_item) {
        if (is_callable(on_item_success)) {
            on_item_success(); 
        }
    } else {
        scr_show_dialog(["Humm, parece que isso não está certo."], "Detetive", c_white);
    }
    
    global.selected_item = ""; 
	global.selected_inventory_slot = -1;
    exit; 
}
if(array_length(dialog_lines) > 0){
	if (click_count == 0 || dialog_lines_repeated == -1) {
		scr_show_dialog(dialog_lines, speaker, text_color);
	} else {
		scr_show_dialog(dialog_lines_repeated, speaker, text_color);
	}
click_count++;
}


if (is_callable(on_interact)) {
    on_interact();
}