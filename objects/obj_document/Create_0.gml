doc_x = display_get_gui_width()  / 2 - 140;
doc_y = display_get_gui_height() / 2 - 160;
doc_w = 400;
metade_h = 200;
texto_visivel = "a figura mais famosa está em primeiro";
texto_oculto  = "triangulo é o primeiro caractere, depois o I."; // declarado para uso futuro — não renderizado aqui

// Gera o rasgo uma única vez (fixo entre frames)
num_segs = 20;
rasgo = array_create(num_segs);
for (var i = 0; i < num_segs; i++) {
    rasgo[i] = irandom_range(-7, 7);
}
