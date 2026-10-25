if(!instance_exists(obj_slide_puzzle_opener)){
image_yscale = 3.5
}
dialog_lines = [
"Esta Sala está trancada.",
"Acho que vou precisar de uma chave para abrí-la"
];

on_item_success = function(){
	global.flags.endroom_unlocked = true;
	
	dialog_lines = ["Essa sala já está destrancada, devo acessá-la pelo menu de movimentação."];
	
	scr_show_dialog("A chave girou perfeitamente! A porta destrancou.", "Detetive", c_white);
}