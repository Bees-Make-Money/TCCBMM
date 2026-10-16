projectile_speed = 3;   
fire_cooldown = 150;    // steps entre disparos (60 = 1 segundo)
cooldown = 0;
detection_range = 4;         // alcance da detecção em células de 48 px

// A geometria é calculada no Room Start, depois do Creation Code.
// Aqui só ficam valores iniciais para evitar erro.
dir_x = 0;
dir_y = 0;
center_x = x;
center_y = y;
zone_x1 = x;
zone_y1 = y;
zone_x2 = x;
zone_y2 = y;