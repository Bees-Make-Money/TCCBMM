function scr_show_dialog(text_array, speaker_name = "Detetive", text_color = c_white){
	if(instance_exists(obj_dialog_box)) exit;
	global.interaction_locked = true;
	var box = instance_create_layer(0, 0, "Text_Dialogs", obj_dialog_box);
	box.text_array = text_array;
	box.speaker = speaker_name;
	box.color = text_color;
}