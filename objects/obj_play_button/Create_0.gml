event_inherited();
x = 50;  
y = 200;  
texto_botao = "JOGAR";
has_save   = scr_has_valid_save();
if (has_save) {
	texto_botao = "NOVO JOGO"
	x =50;
	y = 275;
}