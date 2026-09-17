// ═══════════════════════════════════════════════════════════════
// DRAW GUI EVENT - Renderização Visual Realista e Elegante (816x624)
// ═══════════════════════════════════════════════════════════════
draw_set_font(fnt_testes);
draw_set_alpha(1);

// ── 1. ESTRUTURA DO PAINEL EXTERNO ──
draw_set_color(c_fundo);
draw_rectangle(0, 0, w, h, false);

// Fundo Interno e Grade Técnica
draw_set_color(c_painel);
draw_rectangle(16, 60, w-16, h-70, false);

draw_set_color(make_color_rgb(28, 20, 12));
for(var gx=16; gx<w-16; gx+=24) draw_line(gx, 60, gx, h-70);
for(var gy=60; gy<h-70; gy+=24) draw_line(16, gy, w-16, gy);

// ── 2. SELEÇÃO DE ABAS ──
var c_a1 = (aba == 0) ? c_ouro : c_borda;
var c_a2 = (aba == 1) ? c_ouro : c_borda;

draw_set_color(make_color_rgb(18, 12, 8));
draw_rectangle(180, 16, 390, 52, false);
draw_rectangle(410, 16, 620, 52, false);

draw_set_color(c_a1); draw_rectangle(180, 16, 390, 52, true);
draw_set_color(c_a2); draw_rectangle(410, 16, 620, 52, true);

draw_set_halign(fa_center); draw_set_valign(fa_middle);
draw_set_color(c_a1); draw_text(285, 34, "I. TRANSMISSAO MECANICA");
draw_set_color(c_a2); draw_text(515, 34, "II. PAINEL ELETRICO");

// ── 3. RENDERIZAÇÃO DO PUZZLE SELECIONADO ──
if (aba == 0) {
    // CORREIAS / TRANSMISSÕES
    for(var i=0; i<array_length(conexoes_eng); i++) {
        var p = conexoes_eng[i];
        var i1 = get_eng_idx(p[0]); var i2 = get_eng_idx(p[1]);
        if (i1 != -1 && i2 != -1) {
            var e1 = engrenagens[i1]; var e2 = engrenagens[i2];
            var dir_ang = point_direction(e1.x, e1.y, e2.x, e2.y);
            var nx = lengthdir_x(12, dir_ang + 90);
            var ny = lengthdir_y(12, dir_ang + 90);
            
            draw_set_color(make_color_rgb(30, 22, 14));
            draw_line_width(e1.x + nx, e1.y + ny, e2.x + nx, e2.y + ny, 5);
            draw_line_width(e1.x - nx, e1.y - ny, e2.x - nx, e2.y - ny, 5);
            
            draw_set_color(c_ouro);
            draw_line_width(e1.x + nx, e1.y + ny, e2.x + nx, e2.y + ny, 1);
            draw_line_width(e1.x - nx, e1.y - ny, e2.x - nx, e2.y - ny, 1);
        }
    }

    if (arrastando) {
        var idx = get_eng_idx(arr_from);
        if (idx != -1) {
            draw_set_color(c_ouro);
            draw_line_width(engrenagens[idx].x, engrenagens[idx].y, mouse_xx, mouse_yy, 2);
        }
    }

    // ENGRENAGENS REALISTAS
    for(var i=0; i<array_length(engrenagens); i++) {
        var e = engrenagens[i];
        var cor_rim = c_borda;
        if (e.id == "C" && c_trav) cor_rim = c_verm;
        else if (e.id == "F" && f_trav) cor_rim = c_verm;
        else if (eng_resolvido) cor_rim = c_verde;

        var giro = (i % 2 == 0) ? angulo : -angulo;
        if ((e.id == "C" && c_trav) || (e.id == "F" && f_trav)) giro = 0;

        // Dentes Trapezoidais Vetoriais
        var ri = e.r * 0.78; var ro = e.r;
        for(var d=0; d<e.d; d++) {
            var base_a = (d / e.d) * 2 * pi + degtorad(giro);
            var step_a = (1 / e.d) * 2 * pi;
            
            var a1 = base_a;
            var a2 = base_a + step_a * 0.35;
            var a3 = base_a + step_a * 0.65;
            var a4 = base_a + step_a;

            draw_set_color(c_metal_esc);
            draw_primitive_begin(pr_trianglestrip);
            draw_vertex(e.x + cos(a1)*ri, e.y + sin(a1)*ri);
            draw_vertex(e.x + cos(a2)*ro, e.y + sin(a2)*ro);
            draw_vertex(e.x + cos(a4)*ri, e.y + sin(a4)*ri);
            draw_vertex(e.x + cos(a3)*ro, e.y + sin(a3)*ro);
            draw_primitive_end();

            draw_set_color(cor_rim);
            draw_line(e.x + cos(a2)*ro, e.y + sin(a2)*ro, e.x + cos(a3)*ro, e.y + sin(a3)*ro);
        }

        // Cor do Corpo da Engrenagem
        draw_set_color(c_metal_esc);
        draw_circle(e.x, e.y, ri, false);
        draw_set_color(cor_rim);
        draw_circle(e.x, e.y, ri, true);

        // Furos / Alívio de Peso Industrial
        draw_set_color(c_painel);
        for(var h_i=0; h_i<4; h_i++) {
            var ha = h_i * (pi / 2) + degtorad(giro);
            draw_circle(e.x + cos(ha)*(ri*0.5), e.y + sin(ha)*(ri*0.5), ri*0.18, false);
        }

        // Eixo Central e Chaveta
        draw_set_color(c_metal);
        draw_circle(e.x, e.y, e.r * 0.25, false);
        draw_set_color(make_color_rgb(10, 8, 6));
        draw_circle(e.x, e.y, e.r * 0.12, false);

        // Rótulo da Engrenagem
        draw_set_color(c_ouro);
        draw_set_halign(fa_center); draw_set_valign(fa_bottom);
        draw_text(e.x, e.y - e.r - 4, e.id);
    }
} else {
    // CONDUTORES ELÉTRICOS
    for(var i=0; i<array_length(conexoes_ele); i++) {
        var p = conexoes_ele[i];
        var i1 = get_ele_idx(p[0]); var i2 = get_ele_idx(p[1]);
        if (i1 != -1 && i2 != -1) {
            var n1 = nos_ele[i1]; var n2 = nos_ele[i2];
            draw_set_color(c_verde);
            draw_line_width(n1.x, n1.y, n2.x, n2.y, 3);
            draw_set_color(c_ouro);
            draw_line_width(n1.x, n1.y, n2.x, n2.y, 1);
        }
    }

    if (arrastando) {
        var idx = get_ele_idx(arr_from);
        if (idx != -1) {
            draw_set_color(c_ouro);
            draw_line_width(nos_ele[idx].x, nos_ele[idx].y, mouse_xx, mouse_yy, 2);
        }
    }

    // RENDERIZAÇÃO REALISTA DE COMPONENTES ESQUEMÁTICOS
    for(var i=0; i<array_length(nos_ele); i++) {
        var n = nos_ele[i];

        draw_set_color(make_color_rgb(18, 22, 26));
        draw_rectangle(n.x-22, n.y-16, n.x+22, n.y+16, false);
        draw_set_color(c_borda);
        draw_rectangle(n.x-22, n.y-16, n.x+22, n.y+16, true);

        // Símbolos Esquemáticos
        draw_set_color(c_ouro);
        if (n.tipo == "bat") {
            draw_line_width(n.x-8, n.y-8, n.x-8, n.y+8, 3);
            draw_line_width(n.x+2, n.y-4, n.x+2, n.y+4, 1);
            draw_line_width(n.x+8, n.y-10, n.x+8, n.y+10, 3);
        } else if (n.tipo == "diodo") {
            draw_triangle(n.x-8, n.y-8, n.x-8, n.y+8, n.x+6, n.y, false);
            draw_line_width(n.x+6, n.y-8, n.x+6, n.y+8, 2);
        } else if (n.tipo == "res") {
            draw_line(n.x-12, n.y, n.x-8, n.y-6);
            draw_line(n.x-8, n.y-6, n.x-2, n.y+6);
            draw_line(n.x-2, n.y+6, n.x+4, n.y-6);
            draw_line(n.x+4, n.y-6, n.x+10, n.y+6);
            draw_line(n.x+10, n.y+6, n.x+14, n.y);
        } else if (n.tipo == "cap") {
            draw_line_width(n.x-4, n.y-10, n.x-4, n.y+10, 2);
            draw_line_width(n.x+4, n.y-10, n.x+4, n.y+10, 2);
        } else if (n.tipo == "trans") {
            draw_line_width(n.x-6, n.y-10, n.x-6, n.y+10, 2);
            draw_line(n.x-6, n.y-4, n.x+8, n.y-10);
            draw_line(n.x-6, n.y+4, n.x+8, n.y+10);
        } else if (n.tipo == "fusivel") {
            draw_rectangle(n.x-10, n.y-6, n.x+10, n.y+6, true);
            if (fusivel_queimado) draw_set_color(c_verm);
            draw_line(n.x-10, n.y, n.x+10, n.y);
        } else if (n.tipo == "gnd") {
            draw_line_width(n.x-12, n.y-4, n.x+12, n.y-4, 3);
            draw_line_width(n.x-7, n.y+1, n.x+7, n.y+1, 2);
            draw_line_width(n.x-2, n.y+6, n.x+2, n.y+6, 1);
        }

        // Terminal Conector (Parafuso)
        draw_set_color(c_metal);
        draw_circle(n.x, n.y, 3, false);

        // Identificação Térmica/Código
        draw_set_color(c_borda);
        draw_set_halign(fa_center); draw_set_valign(fa_top);
        draw_text(n.x, n.y + 18, n.id);
    }
}

// ── 4. CADEIA SUPERIOR DE HEADER (SEM DICAS) ──
draw_set_color(make_color_rgb(14, 10, 6));
draw_rectangle(0, 0, w, 60, false);
draw_set_color(c_borda);
draw_line(16, 58, w-16, 58);

draw_set_halign(fa_center); draw_set_valign(fa_top);
draw_set_color(c_ouro);
draw_text(w/2, 8, "SISTEMA DE CONTROLE INDUSTRIAL - UNIDADE ALFA");
draw_set_color(c_borda);
draw_text(w/2, 28, "PAINEL DE REGULAGEM TECNICA — TELEMETRIA EM TEMPO REAL");

// ── 5. PAINEL DE TELEMETRIA INFERIOR (SEM DICAS) ──
draw_set_color(make_color_rgb(10, 8, 6));
draw_rectangle(0, h-70, w, h, false);
draw_set_color(c_borda);
draw_line(0, h-70, w, h-70);

var col_w = (w - 32) / 4;
var st_travas = (!c_trav && !f_trav) ? "DESBLOQUEADO" : "BLOQUEADO";
var st_trans  = eng_resolvido ? "NOMINAL" : "INCOMPLETA";
var st_tensao = string(tensao_out) + "V / 15V";
var st_geral  = (eng_resolvido && ele_resolvido) ? "OPERACIONAL" : "DESENERGIZADO";

if (fusivel_queimado) st_tensao = "SOBRECARGA";

for(var s=0; s<4; s++) {
    var lx = 16 + (s * col_w) + (col_w / 2);
    var t_lbl = ""; var t_val = ""; var c_val = c_borda;

    if (s == 0) { t_lbl = "TRAVAS MEC:"; t_val = st_travas; c_val = (!c_trav && !f_trav) ? c_verde : c_verm; }
    if (s == 1) { t_lbl = "TRANSMISSAO:"; t_val = st_trans; c_val = eng_resolvido ? c_verde : c_ouro; }
    if (s == 2) { t_lbl = "TENSAO OUT:"; t_val = st_tensao; c_val = (tensao_out == 15) ? c_verde : (fusivel_queimado ? c_verm : c_ouro); }
    if (s == 3) { t_lbl = "ESTADO GERAL:"; t_val = st_geral; c_val = (eng_resolvido && ele_resolvido) ? c_verde : c_verm; }

    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_set_color(c_borda);
    draw_text(lx, h - 45, t_lbl);
    draw_set_color(c_val);
    draw_text(lx, h - 25, t_val);
}

// Borda Externa de Acabamento
draw_set_color(c_borda);
draw_rectangle(0, 0, w-1, h-1, true);