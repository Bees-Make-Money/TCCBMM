var cx     = doc_x + doc_w / 2;
var torn_y = doc_y + metade_h;

// Garante que o alinhamento vertical comece sempre pelo topo
draw_set_valign(fa_top);

// ── METADE SUPERIOR (papel amarelado) ──
draw_set_color(make_color_rgb(232, 223, 200));
draw_rectangle(doc_x, doc_y, doc_x+doc_w, torn_y, false);

// Título
draw_set_color(make_color_rgb(42, 31, 14));
draw_set_halign(fa_center);
draw_set_font(fnt_testes);
draw_text(cx, doc_y + 12, "Amor a primeira vista");

// Linha separadora (espaçada abaixo do título)
draw_set_color(make_color_rgb(90, 74, 50));
draw_line(doc_x + 10, doc_y + 34, doc_x + doc_w - 10, doc_y + 34);

// Label fragmento oculto
draw_set_color(make_color_rgb(139, 26, 26));
draw_set_halign(fa_left);
draw_text(doc_x + 14, doc_y + 44, "Morrendo de Saudades");

// Bloco de tinta cobrindo o texto — com margem segura abaixo do label
draw_set_color(make_color_rgb(20, 12, 5));
draw_set_alpha(1);
draw_rectangle(doc_x + 10, doc_y + 64, doc_x + doc_w - 10, doc_y + 90, false);

// Fragmento visível
draw_set_color(make_color_rgb(90, 74, 50));
draw_set_halign(fa_left);
draw_text(doc_x + 14, doc_y + 100, "");
draw_set_color(make_color_rgb(42, 31, 14));
draw_text(doc_x + 14, doc_y + 118, texto_visivel);

// Aviso ao jogador
draw_set_color(make_color_rgb(120, 90, 50));
draw_set_halign(fa_center);
draw_text(cx, doc_y + 144, "");

// ── BORDA RASGADA (fixa, gerada no Create) ──
draw_set_color(make_color_rgb(160, 130, 90));
draw_set_alpha(0.7);
var seg_w = doc_w / num_segs;
for (var i = 0; i < num_segs; i++) {
    var x1 = doc_x + i * seg_w;
    var x2 = doc_x + (i+1) * seg_w;
    var y1 = torn_y + rasgo[i];
    var y2 = torn_y + rasgo[(i+1) mod num_segs];
    draw_line(x1, y1, x2, y2);
}
draw_set_alpha(1);

// ── METADE INFERIOR (papel desgastado) ──
draw_set_color(make_color_rgb(198, 183, 155));
draw_rectangle(doc_x, torn_y + 2, doc_x + doc_w, torn_y + metade_h, false);

draw_set_color(make_color_rgb(90, 74, 50));
draw_set_halign(fa_left);
draw_set_font(fnt_testes);
draw_text(doc_x + 14, torn_y + 12, "Fax Norte-Americano");

draw_set_color(make_color_rgb(42, 31, 14));
draw_text(doc_x + 14, torn_y + 34, "Enviado por: Sabrina");
draw_text(doc_x + 14, torn_y + 54, "Para:[Nome do Dono]");
draw_text(doc_x + 14, torn_y + 74, "Data: 18/08/1993");

draw_set_color(make_color_rgb(120, 90, 50));
draw_text_ext(doc_x + 14, torn_y + 98,
    "Quanto tempo, senti sua falta, não me envia Fax mais hahaha, ainda bem que já já nos encontraremos novamente", -1, doc_w - 20);

// Fechar ([ESC]) com margem correta
draw_set_color(make_color_rgb(100, 60, 30));
draw_set_halign(fa_right);
draw_text(doc_x + doc_w - 8, doc_y + 8, "[ESC]");

if (keyboard_check_pressed(vk_escape))
    instance_destroy();