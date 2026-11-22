event_inherited();
x =50;
y = 355;
btn_w = 220;
btn_h = 52;
texto_botao="CONTINUAR";

// NOME do objeto do seu botão "Novo jogo", entre aspas. TROQUE pelo nome do seu.
newgame_obj_name = "obj_novo_jogo";

has_save   = scr_has_valid_save();
save_info  = has_save ? scr_save_info() : undefined;
hover      = false;
prev_hover = false;
swapped    = false;


if (has_save) {
	x =50;
	y = 200;
	draw_text_transformed(x + btn_w / 2, y + btn_h / 2 - 8, "CONTINUAR", 0.8, 0.8, 0);
    if (save_info != undefined) {
        draw_text_transformed(x + btn_w / 2, y + btn_h / 2 + 12, "Salvo em " + scr_format_datetime(save_info.saved_at), 0.4, 0.4, 0);
    }

}
else {
    // DESATIVADO: placa cinza apagada
    draw_text_transformed(x + btn_w / 2, y + btn_h / 2 - 8, "CONTINUAR", 0.8, 0.8, 0);
    draw_text_transformed(x + btn_w / 2, y + btn_h / 2 + 12, "Nenhum jogo salvo", 0.4, 0.4, 0);
}