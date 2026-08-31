doc_x = display_get_gui_width()  / 2 - 140;
doc_y = display_get_gui_height() / 2 - 160;
doc_w = 280;
metade_h = 150;

texto_visivel = "__ __ 1 0";
texto_oculto  = "3 1 __ __"; // declarado para uso futuro — não renderizado aqui

// Gera o rasgo uma única vez (fixo entre frames)
num_segs = 20;
rasgo = array_create(num_segs);
for (var i = 0; i < num_segs; i++) {
    rasgo[i] = irandom_range(-7, 7);
}
