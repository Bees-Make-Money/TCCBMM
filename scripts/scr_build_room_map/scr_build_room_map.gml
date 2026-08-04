function scr_build_room_map(){
	global.room_map = {}
	global.room_labels = {}
	
//----------Nomes que aparecerão para o jogador a partir do id das salas---------

//Primeiro Andar
scr_set_room_label(rm_hall_entrada, "Hall Entrada")
scr_set_room_label(rm_sala_estar, "Sala de Estar")
scr_set_room_label(rm_sala_jogos, "Sala de Jogos")
scr_set_room_label(rm_cozinha, "Cozinha")
scr_set_room_label(rm_sala_lareira, "Sala de Descanso")

//Segundo Andar

//Terceiro Andar

//Subsolo

//----------Conexões Entre as Salas----------

//Primeiro Andar
scr_add_connection(rm_hall_entrada, rm_cozinha)
scr_add_connection(rm_hall_entrada, rm_sala_estar)

scr_add_connection(rm_sala_estar, rm_sala_jogos)

scr_add_connection(rm_cozinha, rm_sala_lareira)
//Segundo Andar

//Terceiro Andar

//Subsolo

}