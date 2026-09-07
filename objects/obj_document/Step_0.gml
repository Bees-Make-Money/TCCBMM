var cx     = doc_x + doc_w / 2;
var torn_y = doc_y + metade_h;

// ── METADE SUPERIOR (papel amarelado) ──
draw_set_color(make_color_rgb(232, 223, 200));
draw_rectangle(doc_x, doc_y, doc_x+doc_w, torn_y, false);

// Título
draw_set_color(make_color_rgb(42, 31, 14));
draw_set_halign(fa_center);
draw_set_font(fnt_testes);
draw_text(cx, doc_y+12, "ARQUIVO — ACESSO RESTRITO");

// Linha separadora
draw_set_color(make_color_rgb(90, 74, 50));
draw_line(doc_x+10, doc_y+30, doc_x+doc_w-10, doc_y+30);

// Label fragmento oculto
draw_set_color(make_color_rgb(139, 26, 26));
draw_set_halign(fa_left);
draw_text(doc_x+14, doc_y+38, "FRAGMENTO OCULTO:");

// Bloco de tinta cobrindo o texto — completamente opaco
draw_set_color(make_color_rgb(20, 12, 5));
draw_set_alpha(1);
draw_rectangle(doc_x+10, doc_y+54, doc_x+doc_w-10, doc_y+80, false);

// texto_oculto existe no código mas não é renderizado neste puzzle
// draw_text(cx, doc_y+62, texto_oculto); // ← reservado para mecânica futura

// Fragmento visível (sempre legível)
draw_set_color(make_color_rgb(90, 74, 50));
draw_set_halign(fa_left);
draw_text(doc_x+14, doc_y+90, "FRAGMENTO VISÍVEL:");
draw_set_color(make_color_rgb(42, 31, 14));
draw_text(doc_x+14, doc_y+108, texto_visivel);

// Aviso ao jogador
draw_set_color(make_color_rgb(120, 90, 50));
draw_set_halign(fa_center);
draw_set_font(fnt_testes);
draw_text(cx, doc_y+132, "Nós os irmãos Shwizz, estaremos indo no jantar para resolver a negociação da seita");

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
draw_rectangle(doc_x, torn_y+2, doc_x+doc_w, torn_y+metade_h, false);

draw_set_color(make_color_rgb(90, 74, 50));
draw_set_halign(fa_left);
draw_set_font(fnt_testes);
draw_text(doc_x+14, torn_y+12, "— continuação —");

draw_set_color(make_color_rgb(42, 31, 14));
draw_text(doc_x+14, torn_y+35, "Emitido por: [REDIGIDO]");
draw_text(doc_x+14, torn_y+55, "Nível:       [REDIGIDO]");
draw_text(doc_x+14, torn_y+75, "Data:        [REDIGIDO]");

draw_set_color(make_color_rgb(120, 90, 50));
draw_set_font(fnt_testes);
draw_text_ext(doc_x+14, torn_y+100,
    "Documento incompleto. A outra metade\nestá em posse do supervisor — nível 2.", -1, doc_w-20);

// Fechar
draw_set_color(make_color_rgb(100, 60, 30));
draw_set_halign(fa_right);
draw_set_font(fnt_testes);
draw_text(doc_x+doc_w-4, doc_y+4, "[ESC]");

if (keyboard_check_pressed(vk_escape))
    instance_destroy();