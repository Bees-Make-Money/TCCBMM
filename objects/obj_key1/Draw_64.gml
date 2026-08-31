// ── FUNDO ESCURECIDO ──
draw_set_color(make_color_rgb(0, 0, 0));
draw_set_alpha(0.72);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

if (flash_ativo) {
    if (flash_cor) {
        draw_set_color(make_color_rgb(180, 0, 0));
    } else {
        draw_set_color(c_black);
    }
    draw_set_alpha(0.5);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
}

// ── PAINEL PRINCIPAL ──
var cor_painel  = make_color_rgb(26, 18, 8);
var cor_borda   = make_color_rgb(122, 92, 32);
var cor_ouro    = make_color_rgb(200, 150, 30);
var cor_ouro_cl = make_color_rgb(240, 200, 64);
var cor_escuro  = make_color_rgb(5, 7, 10);
var cor_dica    = make_color_rgb(200, 64, 32);
var cor_ok      = make_color_rgb(64, 168, 64);

draw_set_color(cor_painel);
draw_rectangle(px, py, px+pw, py+460, false);
draw_set_color(cor_borda);
draw_rectangle(px, py, px+pw, py+460, true);

// Cantos decorativos
draw_set_color(cor_ouro);
draw_set_alpha(0.7);
// canto sup esq
draw_line(px+8, py+8,   px+20, py+8);
draw_line(px+8, py+8,   px+8,  py+20);
// canto sup dir
draw_line(px+pw-8, py+8,  px+pw-20, py+8);
draw_line(px+pw-8, py+8,  px+pw-8,  py+20);
// canto inf esq
draw_line(px+8, py+460-8,  px+20,    py+460-8);
draw_line(px+8, py+460-8,  px+8,     py+460-20);
// canto inf dir
draw_line(px+pw-8, py+460-8,  px+pw-20, py+460-8);
draw_line(px+pw-8, py+460-8,  px+pw-8,  py+460-20);
draw_set_alpha(1);

draw_set_halign(fa_center);
draw_set_font(fnt_testes);
draw_set_color(cor_ouro);
draw_text(px + pw/2, py+16, "* * *");
draw_text(px + pw/2, py+40, "SALA 1 -- ACESSO RESTRITO");

draw_set_color(make_color_rgb(122, 92, 32));
draw_set_font(fnt_testes);
draw_text(px + pw/2, py+66, "CREDENCIAL NECESSARIA");



// ── DISPLAY (pontos) ──
draw_set_color(cor_escuro);
draw_rectangle(px+20, py+92, px+pw-20, py+125, false);
draw_set_color(make_color_rgb(58, 42, 8));
draw_rectangle(px+20, py+92, px+pw-20, py+125, true);

var dot_y = py + 108;
var dot_r  = 7;
var dot_spacing = 28;
var dot_start = px + pw/2 - dot_spacing*1.5;

for (var i = 0; i < 4; i++) {
    var dot_x = dot_start + i * dot_spacing;
    if (i < string_length(entrada)) {
        draw_set_color(cor_ouro);
        draw_circle(dot_x, dot_y, dot_r, false);
    } else {
        draw_set_color(make_color_rgb(58, 42, 8));
        draw_circle(dot_x, dot_y, dot_r, true);
    }
}

// Botão apagar
draw_set_color(make_color_rgb(90, 64, 16));
draw_set_font(fnt_testes);
draw_set_halign(fa_right);
draw_text(px+pw-28, py+93, "<");

// ── GRID DE BOTÕES (1-9) ──
for (var d = 1; d <= 9; d++) {
    var col = (d-1) mod 3;
    var row = (d-1) div 3;
    var bx  = gx + col * (btn_w + btn_gap);
    var by  = gy + row * (btn_h + btn_gap);

    draw_set_color(make_color_rgb(30, 21, 8));
    draw_rectangle(bx, by, bx+btn_w, by+btn_h, false);
    draw_set_color(make_color_rgb(74, 53, 16));
    draw_rectangle(bx, by, bx+btn_w, by+btn_h, true);

    draw_set_color(make_color_rgb(10, 7, 0));
    draw_line(bx+1, by+btn_h+1, bx+btn_w+1, by+btn_h+1);

    draw_set_color(cor_ouro);
    draw_set_halign(fa_center);
    draw_set_font(fnt_testes);
    draw_text(bx + btn_w/2, by + btn_h/2 - 8, string(d));
}

// ── BOTÃO 0 ──
var zero_y = gy + 3*(btn_h + btn_gap);
var zero_w = btn_w*3 + btn_gap*2;

draw_set_color(make_color_rgb(30, 21, 8));
draw_rectangle(gx, zero_y, gx+zero_w, zero_y+btn_h, false);
draw_set_color(make_color_rgb(74, 53, 16));
draw_rectangle(gx, zero_y, gx+zero_w, zero_y+btn_h, true);
draw_set_color(make_color_rgb(10, 7, 0));
draw_line(gx+1, zero_y+btn_h+1, gx+zero_w+1, zero_y+btn_h+1);
draw_set_color(cor_ouro);
draw_set_halign(fa_center);
draw_text(gx + zero_w/2, zero_y + btn_h/2 - 8, "0");

// ── BOTÃO CONFIRMAR ──
var conf_y  = zero_y + btn_h + 10;
var conf_ativo = (string_length(entrada) == max_digitos);

if (conf_ativo) {
    draw_set_color(make_color_rgb(42, 30, 8));
} else {
    draw_set_color(make_color_rgb(18, 14, 5));
}
draw_rectangle(confirm_x, conf_y, confirm_x+confirm_w, conf_y+44, false);
draw_set_color(conf_ativo ? cor_borda : make_color_rgb(40, 30, 8));
draw_rectangle(confirm_x, conf_y, confirm_x+confirm_w, conf_y+44, true);

draw_set_color(conf_ativo ? cor_ouro : make_color_rgb(60, 45, 15));
draw_set_font(fnt_testes);
draw_set_halign(fa_center);
draw_text(confirm_x + confirm_w/2, conf_y + 14, "C O N F I R M A R");

// ── DICA ──
if (true) {
    draw_set_color(cor_dica);
    draw_set_font(fnt_testes);
    draw_set_halign(fa_center);
    draw_text_ext(px + pw/2, conf_y + 58, dica, -1, pw - 30);
}