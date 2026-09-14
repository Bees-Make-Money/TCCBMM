var cx = x + (largura / 2) - 100;
var cy = y + (altura / 2);
var l = (largura / 2) * escala;
var a = (altura / 2) * escala;

// Corpo do Envelope
draw_set_color(c_envelope);
draw_rectangle(cx - l, cy - a, cx + l, cy + a, false);
draw_set_color(c_contorno);
draw_rectangle(cx - l, cy - a, cx + l, cy + a, true);

// Aba do Envelope
draw_triangle(cx - l, cy - a, cx + l, cy - a, cx, cy - (10 * escala), true);

// Selo de cera
draw_set_color(c_selo);
draw_circle(cx, cy - (10 * escala), 12 * escala, false);
draw_set_color(c_contorno);
draw_circle(cx, cy - (10 * escala), 12 * escala, true);