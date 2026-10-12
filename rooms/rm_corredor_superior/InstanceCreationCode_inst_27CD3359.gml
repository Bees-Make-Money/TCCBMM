dialog_lines = ["Essa porta não abre. Onde posso encontrar uma chave?"];
speaker = "Detetive";
text_color = c_white;

required_item = ITEM_CHAVE_DOURADA;

on_item_success = function(){
	scr_consume_item(ITEM_CHAVE_DOURADA);
	scr_flag_set("corridor_door_unlocked");
	dialog_lines = ["Devo acessar essa sala pelo menu de passagem de salas (como todas as outras ._.)"];
	scr_show_dialog(["Abriu! Que Ótimo!", "Mas... Será que vale a pena entrar?"]);
}
if (scr_flag("corridor_door_unlocked")) {
    dialog_lines = ["Devo acessar essa sala pelo menu de passagem de salas (como todas as outras ._.)"];
}