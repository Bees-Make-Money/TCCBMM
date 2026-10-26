if(!instance_exists(obj_slide_puzzle_opener)){
image_yscale = 3.5
}
dialog_lines = [
"Nunca.",
"Nunca.",
"Não passe."
];
speaker = "??????????????????????";
text_color = c_red

on_item_success = function(){
	global.flags.endroom_unlocked = true;
	
	dialog_lines = ["Essa sala já está destrancada, devo acessá-la pelo menu de movimentação."];
	
	scr_show_dialog("A chave funcionou.... É agora ou nunca.", "Detetive", c_white);
}