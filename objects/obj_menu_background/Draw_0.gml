draw_cover(backgrounds[current], zoom_cur, 1);
if (state == "fading") {
    draw_cover(backgrounds[next], zoom_next, fade_alpha);
}

// Sombra geral
draw_set_color(c_black);
draw_set_alpha(0.4);
draw_rectangle(0, 0, room_width, room_height, false);

// Sombra mais forte à esquerda, onde ficam título e botões
var _w = room_width * 0.65;
draw_primitive_begin(pr_trianglestrip);
draw_vertex_color(0, 0, c_black, 0.75);
draw_vertex_color(0, room_height, c_black, 0.75);
draw_vertex_color(_w, 0, c_black, 0);
draw_vertex_color(_w, room_height, c_black, 0);
draw_primitive_end();

draw_set_alpha(1);
draw_set_color(c_white);