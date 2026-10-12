if (global.interaction_locked) exit

var _paper = instance_create_layer(room_width/2, room_height/2, "Text_Dialogs", obj_lore_papers_full);
if (lore_text != "") _paper.lore_part = lore_text;   // texto próprio deste papel
_paper.on_close = on_close;                           // função de fechamento (se houver)