function scr_get_lore_part(room_id){
	switch(room_id) {
		case rm_hall_entrada:
			return "Definitivamente aconteceu alguma coisa aqui, preciso entender onde estou. Esse texto é somente para descobrir se a quebra de linhas está funcionando corretamente, vou mudar isso depois."
		case rm_varanda_superior:
			return "Humm, prato delicioso"
		case rm_corredor_inferior:
			return "Tem coisa pra colocar aqui hein."
		default:
			return "Essa sala não deveria ter papel de lore, tira daí por favor, abençoado."
	}
}