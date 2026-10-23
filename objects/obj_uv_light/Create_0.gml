persistent = true;

// Profundidade do desenho. Se o feixe/texto ficar ESCONDIDO atrás da luz da lanterna,
// diminua este número (ex.: -60). Se aparecer por cima do inventário, aumente.
depth = -8;

// ---------- cores da luz negra (lanterna de perícia da polícia) ----------
uv_edge = make_color_rgb(70, 40, 220);     // borda do feixe (azul-violeta profundo)
uv_core = make_color_rgb(150, 130, 255);   // centro do feixe (mais claro)
uv_text = { glow: make_color_rgb(70, 60, 255), text: make_color_rgb(190, 205, 255) };

// ---------- tamanho: igual ao da luz original ----------
// -1 = medir automaticamente. Se o tamanho ficar errado, coloque aqui um raio em pixels (ex.: 120).
light_radius_override = -1;

var _area = scr_measure_light_area(spr_flashlight_light);
light_r   = (light_radius_override > 0) ? light_radius_override : _area.r;
light_cdx = _area.cdx;
light_cdy = _area.cdy;
