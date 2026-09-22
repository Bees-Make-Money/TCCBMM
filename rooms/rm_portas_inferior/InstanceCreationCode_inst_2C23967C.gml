dialog_lines = [
"Tem uma fechadura dourada aqui...",
"Acho que vou precisar de uma chave, a porta está trancada."
];
on_item_success = function(){
	global.flags.library_unlocked = true;
	
	dialog_lines = ["Essa sala já está destrancada, devo acessá-la pelo menu de movimentação."];
	
	scr_show_dialog("A chave girou perfeitamente! A porta destrancou.", "Detetive", c_white);
}