lore_text = "Ele tem fome.";
show_if = "fish_taken";            
hide_if = "paintings_solved";      

on_close = function() {
    if (!scr_flag("hunger_paper_read")) {
        scr_flag_set("hunger_paper_read");
        scr_show_dialog([".....", "Fome...", "Volte, você, aqui..."], "???", c_red);
    }
};