if (global.interaction_locked) exit;

if (cooldown > 0) {
    cooldown--;
    exit;
}

if (collision_rectangle(zone_x1, zone_y1, zone_x2, zone_y2, obj_player_topview, false, true) != noone) {
    // Dispara a partir da primeira célula à frente do lançador
    var _p = instance_create_depth(center_x + dir_x * 48, center_y + dir_y * 48, -10, obj_projectile);
    _p.dir_x = dir_x;
    _p.dir_y = dir_y;
    _p.spd = projectile_speed;
    _p.image_angle = image_angle;
    cooldown = fire_cooldown;
}