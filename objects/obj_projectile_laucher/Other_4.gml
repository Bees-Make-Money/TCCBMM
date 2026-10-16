// Direção para onde o lançador aponta (0 = direita, 90 = cima, 180 = esquerda, 270 = baixo)
dir_x = round(lengthdir_x(1, image_angle));
dir_y = round(lengthdir_y(1, image_angle));

// Centro da célula do lançador
center_x = (bbox_left + bbox_right) / 2;
center_y = (bbox_top + bbox_bottom) / 2;

// Área de detecção: as células à frente da face do lançador
var _sx = center_x + dir_x * 24;
var _sy = center_y + dir_y * 24;
var _ex = _sx + dir_x * 48 * detection_range;
var _ey = _sy + dir_y * 48 * detection_range;
zone_x1 = min(_sx, _ex) - abs(dir_y) * 24;
zone_x2 = max(_sx, _ex) + abs(dir_y) * 24;
zone_y1 = min(_sy, _ey) - abs(dir_x) * 24;
zone_y2 = max(_sy, _ey) + abs(dir_x) * 24;