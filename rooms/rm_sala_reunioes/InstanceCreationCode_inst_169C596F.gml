dialog_lines = [];
speaker = "Detetive";
text_color = c_white;

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