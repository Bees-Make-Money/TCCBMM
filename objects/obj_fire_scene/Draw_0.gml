// tremor na falha
if (shake > 0) {
    matrix_set(matrix_world, matrix_build(random_range(-shake, shake), random_range(-shake, shake), 0, 0, 0, 0, 1, 1, 1));
}

draw_hall();
draw_fountain();
for (var i = 0; i < array_length(zones); i++) {
    draw_zone(i);
}
draw_silhouette();
draw_atmosphere();
draw_overlays();

matrix_set(matrix_world, matrix_build_identity());

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
