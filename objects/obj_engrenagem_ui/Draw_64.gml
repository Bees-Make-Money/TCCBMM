var cx = px + pw/2;

// Fundo
draw_set_color(c_black);
draw_set_alpha(0.82);
draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
draw_set_alpha(1);

// ── ABAS ──
// Aba engrenagens
draw_set_color(aba == 0 ? make_color_rgb(42, 30, 8) : cor_painel);
draw_rectangle(aba_eng_x, aba_y, aba_eng_x+aba_w, aba_y+aba_h, false);
draw_set_color(aba_eng_ok ? cor_verde : cor_borda);
draw_rectangle(aba_eng_x, aba_y, aba_eng_x+aba_w, aba_y+aba_h, true);
draw_set_halign(fa_center);
draw_set_valign(fa_middle); // Centraliza na vertical
draw_set_font(fnt_testes);
draw_set_color(aba_eng_ok ? cor_verde : (aba==0 ? cor_ouro : cor_borda));
draw_text(aba_eng_x + aba_w/2, aba_y + aba_h/2, "ENGRENAGENS"); // Coordenada Y matemática

// Aba fiação
draw_set_color(aba == 1 ? make_color_rgb(42, 30, 8) : cor_painel);
draw_rectangle(aba_fio_x, aba_y, aba_fio_x+aba_w, aba_y+aba_h, false);
draw_set_color(aba_fio_ok ? cor_verde : cor_borda);
draw_rectangle(aba_fio_x, aba_y, aba_fio_x+aba_w, aba_y+aba_h, true);
draw_set_color(aba_fio_ok ? cor_verde : (aba==1 ? cor_ouro : cor_borda));
draw_text(aba_fio_x + aba_w/2, aba_y + aba_h/2, "FIACAO"); // Coordenada Y matemática

// ── PAINEL PRINCIPAL ──
draw_set_color(cor_painel);
draw_rectangle(px, py, px+pw, py+ph, false);
draw_set_color(cor_borda);
draw_rectangle(px, py, px+pw, py+ph, true);

// Cantos decorativos
draw_set_color(cor_ouro);
draw_set_alpha(0.7);
draw_line(px+8,    py+8,    px+20,    py+8);
draw_line(px+8,    py+8,    px+8,     py+20);
draw_line(px+pw-8, py+8,    px+pw-20, py+8);
draw_line(px+pw-8, py+8,    px+pw-8,  py+20);
draw_line(px+8,    py+ph-8, px+20,    py+ph-8);
draw_line(px+8,    py+ph-8, px+8,     py+ph-20);
draw_line(px+pw-8, py+ph-8, px+pw-20, py+ph-8);
draw_line(px+pw-8, py+ph-8, px+pw-8,  py+ph-20);
draw_set_alpha(1);

// Título e Instruções (Estes ficam melhores alinhados pelo topo)
draw_set_valign(fa_top);
draw_set_color(cor_ouro);
draw_set_halign(fa_center);
draw_text(cx, py+10, "* * *");
draw_text(cx, py+26, "PAINEL DE MANUTENCAO");
draw_set_color(cor_borda);
draw_line(px+20, py+44, px+pw-20, py+44);

// Instrução no topo
draw_set_color(make_color_rgb(200, 150, 30));
draw_set_halign(fa_center);
draw_text_ext(cx, py+50, instrucao, -1, pw-40);

draw_set_color(cor_borda);
draw_line(px+20, py+72, px+pw-20, py+72);

// ══════════════════════════
// ABA ENGRENAGENS
// ══════════════════════════
if (aba == 0) {

    // Grade de fundo da máquina
    draw_set_color(make_color_rgb(18, 12, 4));
    draw_rectangle(px+10, py+80, px+pw-10, py+ph-84, false);
    draw_set_color(make_color_rgb(30, 20, 8));
    for (var gx = px+10; gx < px+pw-10; gx += 20) {
        draw_line(gx, py+80, gx, py+ph-84);
    }
    for (var gy = py+80; gy < py+ph-84; gy += 20) {
        draw_line(px+10, gy, px+pw-10, gy);
    }

    // Conexões entre engrenagens
    for (var f = 0; f < array_length(conexoes_eng); f++) {
        var c  = conexoes_eng[f];
        var e1 = eng[c.de];
        var e2 = eng[c.para];
        draw_set_color(c.ok ? cor_verde : make_color_rgb(50, 34, 10));
        draw_line_width(e1.ex, e1.ey, e2.ex, e2.ey, c.ok ? 3 : 1);
    }

    // Fio sendo arrastado
    if (arrastando) {
        var eo = eng[arr_origem];
        draw_set_color(cor_ouro);
        draw_line_width(eo.ex, eo.ey, arr_x, arr_y, 2);
    }

    // Desenha engrenagens com dentes
    var letras_eng = ["A","B","C","D"];
    for (var i = 0; i < array_length(eng); i++) {
        var e   = eng[i];
        var dir = (i mod 2 == 0) ? 1 : -1;
        var ang = e.conectada ? (angulo * dir * (eng[0].r / e.r)) : 0;

        // Dentes
        for (var d = 0; d < e.dentes; d++) {
            var a1 = ((d)     / e.dentes) * (2*pi) + ang;
            var a2 = ((d+0.4) / e.dentes) * (2*pi) + ang;
            var a3 = ((d+0.6) / e.dentes) * (2*pi) + ang;
            var a4 = ((d+1)   / e.dentes) * (2*pi) + ang;
            var ri = e.r * 0.78;
            var ro = e.r;
            
            draw_set_color(e.conectada ? make_color_rgb(40,90,20) : make_color_rgb(50,34,10));
            draw_triangle(
                e.ex + cos(a1)*ri, e.ey + sin(a1)*ri,
                e.ex + cos(a2)*ro, e.ey + sin(a2)*ro,
                e.ex + cos(a3)*ro, e.ey + sin(a3)*ro,
                false
            );
            draw_triangle(
                e.ex + cos(a1)*ri, e.ey + sin(a1)*ri,
                e.ex + cos(a3)*ro, e.ey + sin(a3)*ro,
                e.ex + cos(a4)*ri, e.ey + sin(a4)*ri,
                false
            );
        }
        // Círculo base
        draw_set_color(e.conectada ? make_color_rgb(40,90,20) : make_color_rgb(40,28,8));
        draw_circle(e.ex, e.ey, e.r*0.78, false);
        // Borda
        draw_set_color(e.conectada ? cor_verde : cor_borda);
        draw_circle(e.ex, e.ey, e.r, true);
        // Furo central
        draw_set_color(make_color_rgb(10,7,2));
        draw_circle(e.ex, e.ey, e.r*0.22, false);
        
        // Label (Letras da Engrenagem perfeitamente centralizadas)
        draw_set_valign(fa_middle);
        draw_set_color(e.conectada ? cor_verde : cor_ouro);
        draw_set_halign(fa_center);
        draw_set_font(fnt_testes);
        draw_text(e.ex, e.ey, letras_eng[i]); // Removido o "- 8"
    }

    // Porta no canto direito
    draw_set_color(make_color_rgb(30,18,6));
    draw_rectangle(porta_x-8, porta_y-8, porta_x+porta_w+8, porta_y+porta_h+8, false);
    draw_set_color(make_color_rgb(50,32,12));
    draw_rectangle(porta_x, porta_y, porta_x+porta_w, porta_y+porta_h, false);
    draw_set_color(aba_eng_ok ? cor_verde : cor_borda);
    draw_rectangle(porta_x, porta_y, porta_x+porta_w, porta_y+porta_h, true);
    draw_set_color(cor_borda);
    draw_rectangle(porta_x+6, porta_y+6,   porta_x+porta_w-6, porta_y+56,      true);
    draw_rectangle(porta_x+6, porta_y+62,  porta_x+porta_w-6, porta_y+porta_h-6, true);
    draw_set_color(cor_ouro);
    draw_circle(porta_x+porta_w-12, porta_y+porta_h/2, 4, false);
    
    // Cadeado (Texto OK/X centralizado)
    draw_set_color(aba_eng_ok ? make_color_rgb(20,60,20) : make_color_rgb(50,10,5));
    draw_circle(porta_x+porta_w/2, porta_y+porta_h/2, 12, false);
    draw_set_color(aba_eng_ok ? cor_verde : cor_verm);
    draw_circle(porta_x+porta_w/2, porta_y+porta_h/2, 12, true);
    draw_set_color(aba_eng_ok ? cor_verde : cor_verm);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(porta_x+porta_w/2, porta_y+porta_h/2, aba_eng_ok ? "OK" : "X"); // Removido o "- 8"
    
    // Texto Sala 3
    draw_set_color(cor_borda);
    draw_set_valign(fa_bottom); // Alinha pelo fundo para descansar na borda da porta
    draw_text(porta_x+porta_w/2, porta_y-4, "SALA 3");
}

// ══════════════════════════
// ABA FIAÇÃO
// ══════════════════════════
if (aba == 1) {

    // Fundo de placa de circuito
    draw_set_color(make_color_rgb(6, 14, 6));
    draw_rectangle(px+10, py+80, px+pw-10, py+ph-84, false);
    draw_set_color(make_color_rgb(12, 26, 12));
    for (var gx = px+10; gx < px+pw-10; gx += 16) {
        draw_line(gx, py+80, gx, py+ph-84);
    }
    for (var gy = py+80; gy < py+ph-84; gy += 16) {
        draw_line(px+10, gy, px+pw-10, gy);
    }

    // Trilhas decorativas
    draw_set_color(make_color_rgb(20,40,20));
    for (var i = 0; i < 3; i++) {
        var n1 = nos[i];
        var n2 = nos[i+3];
        draw_line(n1.nx, n1.ny, n1.nx, (n1.ny+n2.ny)/2);
        draw_line(n1.nx, (n1.ny+n2.ny)/2, n2.nx, (n1.ny+n2.ny)/2);
        draw_line(n2.nx, (n1.ny+n2.ny)/2, n2.nx, n2.ny);
    }

    // Fios conectados
    for (var f = 0; f < array_length(conexoes_fio); f++) {
        var c  = conexoes_fio[f];
        var n1 = nos[c.de];
        var n2 = nos[c.para];
        var my_mid = (n1.ny + n2.ny) / 2;
        draw_set_color(c.ok ? cor_verde : make_color_rgb(40,70,20));
        draw_line_width(n1.nx, n1.ny, n1.nx, my_mid, c.ok ? 3 : 1);
        draw_line_width(n1.nx, my_mid, n2.nx, my_mid, c.ok ? 3 : 1);
        draw_line_width(n2.nx, my_mid, n2.nx, n2.ny,  c.ok ? 3 : 1);
    }

    // Fio sendo arrastado
    if (arrastando) {
        var no = nos[arr_origem];
        draw_set_color(cor_ouro);
        draw_line_width(no.nx, no.ny, arr_x, arr_y, 2);
    }

    // Nós (Textos alinhados com fa_bottom para não sobrepor o círculo)
    for (var i = 0; i < array_length(nos); i++) {
        var n     = nos[i];
        var lig   = false;
        for (var f = 0; f < array_length(conexoes_fio); f++) {
            if ((conexoes_fio[f].de == i || conexoes_fio[f].para == i) && conexoes_fio[f].ok)
                lig = true;
        }
        draw_set_color(lig ? make_color_rgb(20,50,20) : make_color_rgb(20,30,10));
        draw_circle(n.nx, n.ny, raio_no, false);
        draw_set_color(lig ? cor_verde : cor_borda);
        draw_circle(n.nx, n.ny, raio_no, true);
        draw_set_color(lig ? cor_verde : cor_ouro);
        draw_circle(n.nx, n.ny, 5, false);
        draw_set_color(lig ? cor_verde : cor_ouro);
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_set_font(fnt_testes);
        draw_text(n.nx, n.ny-raio_no-2, n.label); 
    }

    // Status fiação
    draw_set_color(fio_ok >= 3 ? cor_verde : cor_borda);
    draw_set_halign(fa_right);
    draw_set_valign(fa_bottom);
    draw_text(px+pw-16, py+ph-86, "Circuitos: " + string(fio_ok) + "/3");
}

// ── BARRA DE STATUS ──
var centro_y_barra = py + ph - 63; // Y perfeitamente no meio da barra

draw_set_color(make_color_rgb(14, 10, 4));
draw_rectangle(px+10, py+ph-80, px+pw-10, py+ph-46, false);
draw_set_color(cor_borda);
draw_rectangle(px+10, py+ph-80, px+pw-10, py+ph-46, true);

draw_set_valign(fa_middle); // Garante que todos os 3 textos fiquem no centro da barra
draw_set_font(fnt_testes);

draw_set_halign(fa_left);
draw_set_color(aba_eng_ok ? cor_verde : cor_borda);
draw_text(px+18, centro_y_barra, "ENG: " + string(eng_ok) + "/3");

draw_set_halign(fa_center);
draw_set_color(aba_eng_ok && aba_fio_ok ? cor_verde : cor_verm);
draw_text(cx, centro_y_barra, aba_eng_ok && aba_fio_ok ? "SISTEMA ATIVO" : "SISTEMA INATIVO");

draw_set_halign(fa_right);
draw_set_color(aba_fio_ok ? cor_verde : cor_borda);
draw_text(px+pw-18, centro_y_barra, "FIO: " + string(fio_ok) + "/3");

// ── BOTÃO VOLTAR ──
draw_set_color(make_color_rgb(14, 10, 4));
draw_rectangle(btn_voltar_x, btn_voltar_y,
               btn_voltar_x+btn_voltar_w, btn_voltar_y+btn_voltar_h, false);
draw_set_color(cor_borda);
draw_rectangle(btn_voltar_x, btn_voltar_y,
               btn_voltar_x+btn_voltar_w, btn_voltar_y+btn_voltar_h, true);
               
draw_set_color(cor_ouro);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
// Centralizado com base no tamanho matemático do botão
draw_text(btn_voltar_x + btn_voltar_w/2, btn_voltar_y + btn_voltar_h/2, "[ VOLTAR ]"); 

// Reseta os alinhamentos para o padrão do GameMaker (Evita bugar outros Draw Events)
draw_set_halign(fa_left);
draw_set_valign(fa_top);