global.interaction_locked = false;


if (won) {
    global.flags.slide_puzzle_solved = true;
	
	var sprite_pote = object_get_sprite(obj_tooth_pot);
	var largura_pote = sprite_get_width(sprite_pote);
    var distancia = 2 * largura_pote;
    var centro = 408;

    instance_create_layer(centro - distancia, 200, "Instances", obj_lightning_pot);
    instance_create_layer(centro, 200, "Instances", obj_tooth_pot);
    instance_create_layer(centro + distancia, 200, "Instances", obj_zelda_pot);
	
    if (instance_exists(obj_puzzle_doors_paper)){
        instance_destroy(obj_puzzle_doors_paper);
    }
	instance_create_layer(0, 0, "Instances", obj_cutscene_master)
}	