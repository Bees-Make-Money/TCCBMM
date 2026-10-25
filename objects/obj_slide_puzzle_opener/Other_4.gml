if (!global.flags.statue_inspected) {
    instance_destroy();
	exit;
}

if (global.flags.slide_puzzle_solved == true) {
    
    if (global.flags.pot_chosen == false) {
        
        if (!instance_exists(obj_tooth_pot)) {
            var sprite_pote = object_get_sprite(obj_tooth_pot);
            var largura_pote = sprite_get_width(sprite_pote);
            var distancia = 2 * largura_pote;
            var centro = 408;

            instance_create_layer(centro - distancia, 200, "Instances", obj_lightning_pot);
            instance_create_layer(centro, 200, "Instances", obj_tooth_pot);
            instance_create_layer(centro + distancia, 200, "Instances", obj_zelda_pot);
        }
    }
  
    instance_destroy();
	exit;
}