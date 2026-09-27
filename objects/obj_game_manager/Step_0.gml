if (!global.flags.maquina_ligada) {
    if (global.engrenagens_colocadas == global.total_engrenagens && global.flags.fiacao_consertada) {
        global.flags.maquina_ligada = true;
        show_message("A MÁQUINA LIGOU! O mecanismo voltou a funcionar.");
    }
}