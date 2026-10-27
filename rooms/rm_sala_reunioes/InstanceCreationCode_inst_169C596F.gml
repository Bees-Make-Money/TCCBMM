dialog_lines = [];
speaker = "Detetive";
text_color = c_white;
var _lay = layer_get_id("Background");          
var _bg  = layer_background_get_id(_lay); 

on_interact = function() {
    if (scr_flag("flask_taken")) return;
    if (!scr_inventory_has_space()) {
        scr_show_dialog(["Meu inventário está cheio. Preciso liberar espaço antes de usar isto."], "Detetive", c_white);
        return;
    }

    scr_change_room(rm_labirinto_1);
};

if (scr_flag("flask_taken")) {
    dialog_lines = ["O amuleto chegou ao seu limite."];
}

if(scr_flag("fish_taken") && !scr_flag("paintings_solved")){
      
layer_background_sprite(_bg, spr_sala_reunioes_escura);      
}
if(scr_flag("paintings_solved")){
layer_background_sprite(_bg, spr_sala_reunioes); 
}