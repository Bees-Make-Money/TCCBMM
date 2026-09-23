global.interaction_locked = false;


if (won) {
    global.flags.puzzle_solved = true;
	var largura_pote = sprite_get_width(obj_tooth_pot.sprite_index);
    var distancia = 2 * largura_pote;
    var centro = 312;

    instance_create_layer(centro - distancia, 200, "Instances", obj_lightning_pot);
    instance_create_layer(centro, 200, "Instances", obj_tooth_pot);
    instance_create_layer(centro + distancia, 200, "Instances", obj_zelda_pot);
	
    if (instance_exists(obj_puzzle_doors_paper)){
        instance_destroy(obj_puzzle_doors_paper);
    }
	
	dialog_lines = ["De onde vieram estes potes?", "Este hotel está me assustando verdadeiramente..."]
	scr_show_dialog(dialog_lines, "Detetive", c_white)
	scr_show_dialog("Escolha um dos potes. A escolhe errada poderá te fazer dormir para sempre.", "???", c_red)
	scr_show_dialog("Essa voz denovo. Estou começando a ficar assustado.", "Detetive", c_white)
}	