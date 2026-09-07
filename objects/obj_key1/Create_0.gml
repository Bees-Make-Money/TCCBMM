entrada        = "";
senha_correta  = "3110";
tentativas     = 0;
max_digitos    = 4;



// Posição do painel
px = display_get_gui_width()  / 2 - 140;
py = display_get_gui_height() / 2 - 230;
pw = 340;

btn_gap   = 8;
btn_h     = 44;
btn_w     = (pw - 40 - btn_gap * 2) / 3;
gx        = px + 20;
gy        = py + 130;
confirm_w = pw - 40;
confirm_x = px + 20;
confirm_y = gy + (btn_h + btn_gap) * 4 + 10;
// Botão confirmar
confirm_x = px + 20;
confirm_y = gy + (btn_h + btn_gap) * 4 + 10;
confirm_w = pw - 40;
confirm_h = 44;

confirm_x = px + 20;
confirm_y = py + 130 + 4*(44+8) + 10; // logo abaixo do botão 0
confirm_w = pw - 40;
flash_ativo  = false;
flash_timer  = 0;
flash_duracao = 8; // frames totais do efeito
flash_cor    = false; // alterna entre vermelho e preto
verificar_senha = function() {
    if (entrada == senha_correta) {
        obj_door1.bloqueada = false;
       instance_destroy();
        room_goto(rm_sala_negocios_1);
    } else {
        tentativas++;
        entrada = "";
        var idx = min(tentativas - 1, array_length(dicas) - 1);
       

        // Ativa o flash
        flash_ativo = true;
        flash_timer = flash_duracao;
    }
}