if(!instance_exists(obj_dialog_box)){
	switch (room){
	case (rm_portas_inferior):
		if (step == 0){
			dialog_lines = ["De onde vieram estes potes?", "Este hotel está me assustando."];
			scr_show_dialog(dialog_lines, "Detetive", c_white);
			step++;
		}
		else if (step == 1){
			dialog_lines = ["Escolha um dos potes. A escolhe errada poderá te fazer dormir para sempre."];
			scr_show_dialog(dialog_lines, "???", c_red);
			step++;
		}
		else if	(step == 2){
			dialog_lines = ["Essa voz denovo...", "Há algo que eu definitivamente preciso descobrir..."];
			scr_show_dialog(dialog_lines, "Detetive", c_white);
			step++;
		}
		else if (step == 3){
			step = 0;
			instance_destroy();
		}
	break;
	
	//Aqui a gente adiciona o controle de cutscenes de outras salas.
	
	default:
		scr_show_dialog(["Quanto mais eu entro no hotel, mais estranho ele fica."], "Detetive", c_white);
		instance_destroy();
	break;
	}
}
