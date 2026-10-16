dialog_lines = [];
speaker = "Detetive";
text_color = c_white;

on_interact = function() {
    if (!scr_flag("flask_taken")) {
        scr_change_room(rm_labirinto_1);
    }
};

if (scr_flag("flask_taken")) {
    dialog_lines = ["O amuleto chegou ao seu limite."];
}