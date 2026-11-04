dialog_lines = [
"Nunca.",
"Nunca.",
"Não passe."
];
speaker = "??????????????????????";
text_color = c_red

required_item = ITEM_CHAVE_NEGRA;

on_item_success = function() {
    scr_consume_item(ITEM_CHAVE_NEGRA);
    scr_flag_set("endroom_unlocked");
    dialog_lines = ["Porta já destrancada: devo acessá-la pelo menu de movimentação"];
    scr_show_dialog(["Funcionou... É agora ou nunca."], "Detetive", c_white);
};

if (scr_flag("endroom_unlocked")) {
    dialog_lines = ["Porta já destrancada: devo acessá-la pelo menu de movimentação"];
}

// Esta porta se sobrepõe ao papel do slide puzzle: só responde quando o papel não existe
click_condition = function() { return !instance_exists(obj_slide_puzzle_opener); };