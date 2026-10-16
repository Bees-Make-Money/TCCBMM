if (global.interaction_locked) exit

var _paper = instance_create_layer(room_width/2, room_height/2, "Text_Dialogs", obj_lore_papers_full);
_paper.lore_part = (lore_text != "") ? lore_text : scr_get_lore_part(room);   // texto próprio deste papel
if(is_callable(on_click)){
	on_click();
}
_paper.on_close = on_close; // função de fechamento (se houver)