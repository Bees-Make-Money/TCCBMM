function scr_build_room_map(){
	global.room_map = {}
	global.room_labels = {}
	
//----------Nomes que aparecerão para o jogador a partir do id das salas---------

//Primeiro Andar
scr_set_room_label(rm_hall_entrada, "Hall de Entrada")
scr_set_room_label(rm_portas_inferior, "Portas Inferiores")
scr_set_room_label(rm_corredor_inferior, "Corredor Inferior")
scr_set_room_label(rm_cozinha, "Cozinha")
scr_set_room_label(rm_puzzle_chave_1, "Sala Puzzle Chave Vermelha")
scr_set_room_label(rm_biblioteca, "Biblioteca")
scr_set_room_label(rm_puzzle_chave_2, "Sala Puzzle Chave Azul")

//Segundo Andar
scr_set_room_label(rm_varanda_superior, "Varanda Superior")
scr_set_room_label(rm_corredor_superior, "Corredor Superior")
scr_set_room_label(rm_sala_reunioes, "Sala de Reuniões")

//----------Conexões Entre as Salas----------

//Primeiro Andar
scr_add_connection(rm_hall_entrada, rm_varanda_superior)
scr_add_connection(rm_hall_entrada, rm_portas_inferior)

scr_add_connection(rm_portas_inferior, rm_corredor_inferior)
scr_add_connection(rm_portas_inferior, rm_biblioteca)

scr_add_connection(rm_corredor_inferior, rm_cozinha)

scr_add_connection(rm_cozinha, rm_puzzle_chave_1)

scr_add_connection(rm_biblioteca, rm_puzzle_chave_2)

//Segundo Andar
scr_add_connection(rm_varanda_superior, rm_corredor_superior)

scr_add_connection(rm_corredor_superior, rm_sala_reunioes)


}