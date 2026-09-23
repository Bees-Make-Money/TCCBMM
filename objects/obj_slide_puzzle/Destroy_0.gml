global.interaction_locked = false;

if (won) {
    global.flags.puzzle_solved = true;
    
    if (instance_exists(obj_puzzle_doors_paper)){
        instance_destroy(obj_puzzle_doors_paper);
    }
    
    var _cria_pote = function(_x, _y, _sprite, _nome_item, _msg) {
        var _pote = instance_create_layer(_x, _y, "Instances", obj_hotspot_base);
        _pote.sprite_index = _sprite;
        _pote.dialog_lines = [_msg];
        
        _pote.on_interact = function() {
            var _item_nome = id._nome_item_interno;
            var _item_spr = id._sprite_interno;
            
            if (scr_add_item_to_inventory(_item_spr, _item_nome)) {
                scr_show_dialog(["Peguei o " + _item_nome + ". Os outros potes sumiram misteriosamente."], "Detetive", c_white);

                with (obj_hotspot_base) {
                    if (variable_instance_exists(id, "is_pote")) {
                        instance_destroy();
                    }
                }
            } else {
                scr_show_dialog(["Meu inventário está cheio."], "Detetive", c_white);
            }
        };
        
        _pote.is_pote = true; 
        _pote._nome_item_interno = _nome_item;
        _pote._sprite_interno = _sprite;
    };
    
    _cria_pote(300, 500, spr_lightining_bucket, "pote_raio", "Um pote com uma enorme energia contida");
    _cria_pote(500, 500, spr_zelda_bucket, "pote_triforce", "Um pote que guarda uma linda história");
    _cria_pote(700, 500, spr_tooth_bucket, "pote_dente", "Um pote com o dente do protagonista escamoso");
    
    scr_show_dialog(["O que é isso?!", "Três potes surgiram no chão...", "Seria uma boa ideia pegar um deles?"], "Detetive", c_white);
}