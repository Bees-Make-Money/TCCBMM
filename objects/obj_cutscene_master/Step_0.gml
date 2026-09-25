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
	
	case (rm_hall_entrada):
		if (global.flags.pot_chosen){
			if (step == 0){
				dialog_lines = ["Você não era tão esperto quanto eu esperava...", "É uma pena.", "Adeus."];
				scr_show_dialog(dialog_lines, "???", c_red);
				step++;
			}
			else if (step == 1){
				with (obj_statue) { 
					image_alpha -= 0.02; 
                        
                    if (image_alpha <= 0) {
						sprite_index = spr_sprite;
                        image_index = 0; // Garante que começa do primeiro frame
                        image_speed = 0; // Mantém a animação pausada por enquanto
                        image_alpha = 1; // Restaura a opacidade para 100%
                            
                        other.step++; 
                        }
                    }
			}
			else if (step == 2){
				with (obj_statue) {
					image_speed = 1; // Velocidade normal da animação    
                    // Checa se o frame atual é o último frame do sprite
                    if (image_index >= image_number - 1) {
						image_speed = 0; // Pausa no último frame
                        other.step++;
                        }
                    }
			}
			else if (step == 3){
				instance_create_depth(0, 0, -9999, obj_death);
				instance_destroy();
			}		
		}
	break;
	
	default:
		scr_show_dialog(["Quanto mais eu entro no hotel, mais estranho ele fica."], "Detetive", c_white);
		instance_destroy();
	break;
	}
}
