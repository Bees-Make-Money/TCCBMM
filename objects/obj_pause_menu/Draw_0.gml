if (!open) exit;

var _cx = room_width / 2;
var _cy = room_height / 2;

var _brass    = make_color_rgb(181, 148, 70);
var _brass_dk = make_color_rgb(110, 84, 34);
var _brass_lt = make_color_rgb(232, 206, 130);
var _wood_top = make_color_rgb(92, 46, 28);
var _wood_bot = make_color_rgb(50, 23, 14);

// escurece o jogo por trás
draw_set_alpha(0.72);
draw_set_color(c_black);
draw_rectangle(0, 0, room_width, room_height, false);
draw_set_alpha(1);

// painel de mogno com filetes de latão
draw_rectangle_color(_cx - 190, _cy - 170, _cx + 190, _cy + 170, _wood_top, _wood_top, _wood_bot, _wood_bot, false);
draw_set_color(_brass);
draw_rectangle(_cx - 186, _cy - 166, _cx + 186, _cy + 166, true);
draw_set_color(_brass_dk);
draw_rectangle(_cx - 183, _cy - 163, _cx + 183, _cy + 163, true);

draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// título
var _title = "PAUSA";
if (mode == "confirm_reset") _title = "RESETAR?";
else if (mode == "saving")   _title = "SALVO";
draw_set_color(_brass_lt);
draw_text_transformed(_cx, _cy - 130, _title, 1.3, 1.3, 0);
draw_set_color(_brass_dk);
draw_line_width(_cx - 120, _cy - 108, _cx + 120, _cy - 108, 2);

// textos dos outros modos
if (mode == "confirm_reset") {
    draw_set_color(make_color_rgb(235, 220, 190));
    draw_text_ext_transformed(_cx, _cy - 76, "Todo o progresso atual será perdido.", -1, 320 / 0.7, 0.7, 0.7, 0);
}
if (mode == "saving") {
    draw_set_color(make_color_rgb(235, 220, 190));
    draw_text_ext_transformed(_cx, _cy, "Progresso salvo.#Fechando o jogo...", -1, 320 / 0.9, 0.9, 0.9, 0);
}

// botões
var _labels = [];
if (mode == "main")               _labels = ["Continuar", "Salvar e sair", "Resetar progresso"];
else if (mode == "confirm_reset") _labels = ["Sim, resetar", "Não, voltar"];

for (var i = 0; i < array_length(_labels); i++) {
    var _r   = btn_rect(i);
    var _hot = (hover == i);
    var _c1  = _hot ? _brass_lt : _brass;
    var _c2  = _hot ? _brass : _brass_dk;
    draw_rectangle_color(_r[0], _r[1], _r[2], _r[3], _c1, _c1, _c2, _c2, false);
    draw_set_color(_hot ? c_white : _brass_dk);
    draw_rectangle(_r[0], _r[1], _r[2], _r[3], true);
    draw_set_color(make_color_rgb(60, 36, 10));
    draw_text_transformed((_r[0] + _r[2]) / 2, (_r[1] + _r[3]) / 2, _labels[i], 0.8, 0.8, 0);
}

// aviso (ex.: não dá para salvar agora)
if (msg_t > 0) {
    draw_set_alpha(min(1, msg_t / 30));
    draw_set_color(make_color_rgb(255, 150, 120));
    draw_text_ext_transformed(_cx, _cy + 148, msg, -1, 330 / 0.6, 0.6, 0.6, 0);
    draw_set_alpha(1);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
