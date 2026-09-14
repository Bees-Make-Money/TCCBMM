draw_set_font(fnt_testes);

// 1. Fundo Escurecido (Foca a atenção no manual)
draw_set_alpha(0.8);
draw_set_color(c_fundo_escuro);
draw_rectangle(0, 0, w, h, false);
draw_set_alpha(1);

// 2. Fundo do Papel
draw_set_color(c_papel_borda);
draw_rectangle(bx1 + 5, by1 + 5, bx2 + 5, by2 + 5, false); // Sombra
draw_set_color(c_papel);
draw_rectangle(bx1, by1, bx2, by2, false);
draw_set_color(c_tinta);
draw_rectangle(bx1, by1, bx2, by2, true);

// Botão Fechar (X)
draw_set_color(c_alerta);
draw_text(bx2 - 25, by1 + 15, "X");
draw_rectangle(bx2 - 35, by1 + 10, bx2 - 15, by1 + 30, true);

draw_set_color(c_tinta);

// 3. Renderização das Páginas
switch (pag_atual) {
    
    case 0: // CAPA
        draw_set_halign(fa_center);
        draw_text(w/2, by1 + 80, "MANUAL DE OPERACAO - UNIDADE ALFA");
        draw_line(w/2 - 150, by1 + 110, w/2 + 150, by1 + 110);
        
        draw_set_halign(fa_left);
        draw_text(bx1 + 60, by1 + 160, "Este documento contem os diagramas e as instrucoes\nnecessarias para a calibracao do painel de telemetria.");
        draw_text(bx1 + 60, by1 + 240, "INSTRUCOES GERAIS:");
        draw_text(bx1 + 80, by1 + 270, "1. O sistema e dividido em Transmissao e Eletrica.");
        draw_text(bx1 + 80, by1 + 300, "2. Clique e arraste para conectar os componentes.");
        draw_text(bx1 + 80, by1 + 330, "3. Siga estritamente as regras de seguranca nas\n   paginas seguintes para evitar danos ao equipamento.");
        break;

    case 1: // MECÂNICA
        draw_set_halign(fa_center);
        draw_text(w/2, by1 + 30, "I. TRANSMISSAO MECANICA");
        draw_line(bx1 + 40, by1 + 60, bx2 - 40, by1 + 60);
        
        draw_set_halign(fa_left);
        draw_text(bx1 + 40, by1 + 80, "DIRETRIZES:");
        draw_text(bx1 + 60, by1 + 110, "- Ligue a cadeia sequencial do Motor (A) a Saida (OUT).");
        draw_set_color(c_alerta);
        draw_text(bx1 + 60, by1 + 140, "- ATENCAO: As engrenagens C e F estao travadas.");
        draw_text(bx1 + 60, by1 + 170, "- Conecte o volante H em C, e o volante I em F para liberar.");
        
        // Desenho Geométrico - Engrenagens
        var cx = bx1 + 100; var cy = by1 + 300;
        draw_set_color(c_diagrama);
        
        // Linha pontilhada base
        for(var i=0; i<4; i++) { draw_line(cx + (i*90), cy, cx + (i*90) + 40, cy); }
        
        // Engrenagem A, B, C
        draw_circle(cx, cy, 20, true); draw_text(cx - 5, cy - 8, "A");
        draw_circle(cx + 90, cy, 15, true); draw_text(cx + 85, cy - 8, "B");
        
        draw_set_color(c_alerta); // Engrenagem C (Travada)
        draw_circle(cx + 180, cy, 20, true); draw_text(cx + 175, cy - 8, "C");
        
        // Destrave H -> C
        draw_set_color(c_diagrama);
        draw_line(cx + 180, cy - 20, cx + 180, cy - 60);
        draw_circle(cx + 180, cy - 75, 15, true); draw_text(cx + 175, cy - 83, "H");
        
        draw_set_color(c_tinta_clara);
        draw_text(cx + 205, cy - 83, "<- Pino de Destrave");
        
        draw_set_color(c_diagrama);
        draw_circle(cx + 270, cy, 15, true); draw_text(cx + 265, cy - 8, "D");
        draw_text(cx + 310, cy - 8, "... ate OUT");
        break;

    case 2: // ELÉTRICA
        draw_set_halign(fa_center);
        draw_set_color(c_tinta);
        draw_text(w/2, by1 + 30, "II. CIRCUITO ELETRICO");
        draw_line(bx1 + 40, by1 + 60, bx2 - 40, by1 + 60);
        
        draw_set_halign(fa_left);
        draw_text(bx1 + 40, by1 + 80, "DIRETRIZES:");
        draw_text(bx1 + 60, by1 + 110, "- A saida final (OUT) exige EXATOS 15 Volts para operar.");
        draw_set_color(c_alerta);
        draw_text(bx1 + 60, by1 + 140, "- O fusivel na linha J3 queima se a tensao passar de 15V.");
        draw_set_color(c_tinta);
        draw_text(bx1 + 60, by1 + 170, "- Aterre a juncao J2 e a linha K1 conectando-os aos pinos GND.");
        draw_text(bx1 + 60, by1 + 200, "- O Diodo D1 possui polaridade: so aceita a Fonte BAT-A.");

        // Desenho Geométrico - Diagrama Elétrico
        var ex = bx1 + 120; var ey = by1 + 320;
        draw_set_color(c_diagrama);
        
        // Bateria -> Diodo -> Junção
        draw_rectangle(ex, ey - 20, ex + 40, ey + 20, true);
        draw_text(ex + 5, ey - 8, "BAT");
        draw_line(ex + 40, ey, ex + 80, ey);
        
        // Símbolo Diodo
        draw_triangle(ex + 80, ey - 10, ex + 80, ey + 10, ex + 100, ey, true);
        draw_line(ex + 100, ey - 10, ex + 100, ey + 10);
        draw_text(ex + 85, ey - 30, "D1");
        
        draw_line(ex + 100, ey, ex + 140, ey);
        draw_circle(ex + 150, ey, 10, true); draw_text(ex + 145, ey - 8, "J1");
        
        // Junção J3 e Fusível
        draw_line(ex + 160, ey, ex + 200, ey);
        draw_circle(ex + 210, ey, 10, true); draw_text(ex + 205, ey - 8, "J3");
        
        draw_set_color(c_alerta);
        draw_line(ex + 220, ey, ex + 240, ey);
        draw_rectangle(ex + 240, ey - 10, ex + 280, ey + 10, true);
        draw_text(ex + 245, ey - 30, "FUS");
        draw_text(ex + 242, ey + 15, "Max 15V");
        
        draw_set_color(c_diagrama);
        draw_line(ex + 280, ey, ex + 320, ey);
        draw_circle(ex + 320, ey, 5, false); draw_text(ex + 330, ey - 8, "OUT");
        break;
}

// 4. Botões de Navegação
draw_set_color(c_tinta);
draw_set_halign(fa_center);

if (pag_atual > 0) {
    draw_rectangle(bx1 + 20, by2 - 50, bx1 + 140, by2 - 10, true);
    draw_text(bx1 + 80, by2 - 40, "<- ANTERIOR");
}
if (pag_atual < pag_max) {
    draw_rectangle(bx2 - 140, by2 - 50, bx2 - 20, by2 - 10, true);
    draw_text(bx2 - 80, by2 - 40, "PROXIMA ->");
}

draw_set_halign(fa_left); // Reseta alinhamento