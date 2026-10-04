 event_inherited();

    item_name = "Engrenagem";

    custom_click = function() {
        if (scr_add_item_to_inventory(sprite_index, item_name)) {
            instance_destroy();
        }
        // se o inventário estiver cheio, a engrenagem continua
        // no chão e o jogador pode tentar de novo depois
    }
